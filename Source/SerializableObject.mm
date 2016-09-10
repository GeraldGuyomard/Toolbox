/*
 *  SerializableObject.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "SerializableObject.h"
#include <map>

@interface SerializableObjectWrapper : NSObject<NSCoding>
{
@public
	Toolbox::P_SerializableObject object;
}

-(id) initWithObject:(Toolbox::SerializableObject*)iObject;

@end

@implementation SerializableObjectWrapper

-(id) initWithObject:(Toolbox::SerializableObject*)iObject
{
	if (self = [super init])
	{
		object = iObject;
	}
	
	return self;
}

static NSString* kClassNameKey = @"ClassName";

-(id) initWithCoder:(NSCoder*)aDecoder
{
	if (self = [super init])
	{
		Toolbox::SerializableObject::decodeFromWrapper(object, aDecoder);
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	object->encodeToWrapper(aCoder);
}

@end

namespace Toolbox
{

	
SerializableObject::~SerializableObject()
{}
	
void SerializableObject::_encode(NSCoder* aCoder)
{}
	
void SerializableObject::_decode(NSCoder* aDecoder)
{}
	
	
#pragma mark -
	
static std::map<std::string, TNewFct> s_ClassName2NewFct;
	
void SerializableObject::registerClass(const std::string& iClassName, TNewFct iNewFct)
{
	s_ClassName2NewFct[iClassName] = iNewFct;
}
	
void SerializableObject::encode(SerializableObject* iObject, NSCoder* aCoder, NSString* const iKey)
{
	SerializableObjectWrapper* wrapper = [[SerializableObjectWrapper alloc] initWithObject:iObject];
	[aCoder encodeObject:wrapper forKey:iKey];
	[wrapper release];
}

void SerializableObject::decode(P_SerializableObject& oObject, NSCoder* aDecoder, NSString* const iKey)
{
	SerializableObjectWrapper* wrapper = [aDecoder decodeObjectForKey:iKey];
	oObject = wrapper->object;
}

void SerializableObject::newFromClassName(const std::string& iClassName, P_SerializableObject& oObject)
{
	oObject = NULL;
	
	std::map<std::string, TNewFct>::iterator it = s_ClassName2NewFct.find(iClassName);
	if (it == s_ClassName2NewFct.end())
	{
		return;
	}
	
	TNewFct newFct = (*it).second;
	TB_ASSERT(NULL != newFct);
	
	newFct(oObject);
}

void SerializableObject::encodePod(const void* iStruct, size_t iSize, NSCoder* aCoder, NSString* iKey)
{
	[aCoder encodeBytes:(const uint8_t*)iStruct length:iSize forKey:iKey];	
}

void SerializableObject::decodePod(void* oStruct, size_t iSize, NSCoder* aCoder, NSString* iKey)
{
	NSUInteger l;
	const void* bytes = [aCoder decodeBytesForKey:iKey returnedLength:&l];
	TB_ASSERT(l == iSize);
	memcpy(oStruct, bytes, l);
}
	
void SerializableObject::encodeObjectArray(const std::vector<P_SerializableObject>& iArray, NSCoder* aCoder, NSString* iKey)
{
	// Create a mirrored NSArray from the given vector
	NSUInteger length = iArray.size();
	NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:length];
	
	for (NSUInteger i=0; i < length; ++i)
	{
		SerializableObjectWrapper* wrapper = [[SerializableObjectWrapper alloc] initWithObject:iArray[i]];
		[array addObject:wrapper];
		[wrapper release];
	}
	
	[aCoder encodeObject:array forKey:iKey];
	[array release];
}

void SerializableObject::decodeObjectArray(std::vector<P_SerializableObject>& oArray, NSCoder* aDecoder, NSString* iKey)
{
	NSArray* array = [aDecoder decodeObjectForKey:iKey];
	
	const NSUInteger count = [array count];
	oArray.resize(count);
	
	for (NSUInteger i=0; i < count; ++i)
	{
		SerializableObjectWrapper* wrapper = [array objectAtIndex:i];
		oArray[i] = wrapper->object;
	}
}
	
void SerializableObject::decodeFromWrapper(P_SerializableObject& oObject, NSCoder* iDecoder)
{
	NSUInteger length = 0;
	const char* s = (const char*) [iDecoder decodeBytesForKey:kClassNameKey returnedLength:&length];
	
	std::string className = s;
	
	Toolbox::SerializableObject::newFromClassName(className, oObject);
	oObject->_decode(iDecoder);
}
	
void SerializableObject::encodeToWrapper(NSCoder* iCoder)
{
	std::string n = className();
	
	[iCoder encodeBytes:(const uint8_t*)n.c_str() length:n.length() + 1 forKey:kClassNameKey];
	_encode(iCoder);	
}
	
} // End of toolbox