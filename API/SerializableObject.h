/*
 *  SerializableObject.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_SerializableObject_H_)
#define _SerializableObject_H_

#include "BasicTypes.h"
#include "RetainedObject.h"
#include <string>
#include <vector>

#define TB_DECLARE_ABSTRACT_SERIALIZABLE_OBJECT(ClassName, SuperClassName) \
typedef SuperClassName SuperClass; \
virtual std::string className() const \
{ \
	return #ClassName; \
} \

#define TB_DECLARE_SERIALIZABLE_OBJECT(ClassName, SuperClassName) \
TB_DECLARE_ABSTRACT_SERIALIZABLE_OBJECT(ClassName, SuperClassName) \
static void newInstance(P_SerializableObject& oObject) \
{ \
oObject = new ClassName; \
} \
static void registerClass() \
{ \
SerializableObject::registerClass(#ClassName, &(ClassName::newInstance)); \
} \


namespace Toolbox
{
	class SerializableObject;
	typedef TSmartPtr<SerializableObject> P_SerializableObject;
	
	typedef void (*TNewFct)(P_SerializableObject& oObject);
	
	class SerializableObject : public RetainedObject<SerializableObject>
	{
	public:
		
		static void registerClass(const std::string& iClassName, TNewFct iNewFct);

		static void encode(SerializableObject* iObject, NSCoder* aCoder, NSString* kKey);
		
		static void decode(P_SerializableObject& oObject, NSCoder* aDecoder, NSString* kKey);
		template <class TObject> static void decode(TSmartPtr<TObject>& oObject, NSCoder* aDecoder, NSString* kKey);

		// Helper functions to serialize members
		static void encodePod(const void* iStruct, size_t iSize, NSCoder* aCoder, NSString* iKey);
		static void decodePod(void* oStruct, size_t iSize, NSCoder* aCoder, NSString* iKey);
		
		template <typename TPod> static void encodePod(const TPod& iPodObject, NSCoder* aCoder, NSString* iKey);
		template <typename TPod> static void decodePod(TPod& oPodObject, NSCoder* aDecoder, NSString* iKey);
		
		template <typename TPod> static void encodePodArray(const std::vector<TPod>& iArray, NSCoder* aCoder, NSString* iKey);
		template <typename TPod> static void decodePodArray(std::vector<TPod>& oArray, NSCoder* aDecoder, NSString* iKey);
		
		static void encodeObjectArray(const std::vector<P_SerializableObject>& iArray, NSCoder* aCoder, NSString* iKey);
		template <class TSerializableObject> static void encodeObjectArray(const std::vector<TSmartPtr<TSerializableObject> >& iArray, NSCoder* aCoder, NSString* iKey);
		
		static void decodeObjectArray(std::vector<P_SerializableObject>& oArray, NSCoder* aDecoder, NSString* iKey);
		template <class TSerializableObject> static void decodeObjectArray(std::vector<TSmartPtr<TSerializableObject> >& oArray, NSCoder* aDecoder, NSString* iKey);
		
		//

		static void newFromClassName(const std::string& iClassName, P_SerializableObject& oObject);
		
		virtual ~SerializableObject();
		
		virtual std::string className() const
		{
			return "SerializableObject";
		}
		
		// Not public
		static void decodeFromWrapper(P_SerializableObject& oObject, NSCoder* iDecoder);
		void encodeToWrapper(NSCoder* iCoder);
		
	protected:
		// Do nothing
		virtual void _encode(NSCoder* aCoder);
		virtual void _decode(NSCoder* aDecoder);
	};
	
	// ******************************************************************
	// Inlined implementations
	// ******************************************************************
	template <class TObject> void SerializableObject::decode(TSmartPtr<TObject>& oObject, NSCoder* aDecoder, NSString* kKey)
	{
		P_SerializableObject obj;
		decode(obj, aDecoder, kKey);
		// Here to do : dynamic cast
		oObject = (TObject*) obj.object();
	}
	
	template <typename TPod> inline void SerializableObject::encodePod(const TPod& iPodObject, NSCoder* aCoder, NSString* iKey)
	{
		encodePod(&iPodObject, sizeof(TPod), aCoder, iKey);	
	}
	
	template <typename TPod> inline void SerializableObject::decodePod(TPod& oPodObject, NSCoder* aDecoder, NSString* iKey)
	{
		decodePod(&oPodObject, sizeof(TPod), aDecoder, iKey);
	}
	
	template <typename TPod> void inline SerializableObject::encodePodArray(const std::vector<TPod>& iArray, NSCoder* aCoder, NSString* iKey)
	{
		const NSUInteger arraySize = sizeof(TPod) * iArray.size();
		const NSUInteger l = sizeof(NSUInteger) + arraySize;
		
		NSMutableData* data = [NSMutableData dataWithCapacity:l];
		[data appendBytes:&l length:sizeof(l)];
		[data appendBytes:&iArray[0] length:arraySize]; 
		 
		[aCoder encodeBytes:(const uint8_t*) [data mutableBytes] length:l forKey:iKey];
	}
	
	template <typename TPod> inline void SerializableObject::decodePodArray(std::vector<TPod>& oArray, NSCoder* aDecoder, NSString* iKey)
	{
		NSUInteger l;
		const uint8_t* buffer = [aDecoder decodeBytesForKey:iKey returnedLength:&l];
		TB_ASSERT(l >= sizeof(NSUInteger));
		NSUInteger count = *((const NSUInteger*) buffer);
		
		TB_ASSERT((sizeof(count) + (count * sizeof(TPod))) == l);
		oArray.resize(count);
		memcpy(&oArray[0], buffer + sizeof(count), count * sizeof(TPod));
	}
	
	template <class TSerializableObject> inline void SerializableObject::encodeObjectArray(const std::vector<TSmartPtr<TSerializableObject> >& iArray, NSCoder* aCoder, NSString* iKey)
	{
		encodeObjectArray((const std::vector<P_SerializableObject>&) iArray, aCoder, iKey);
	}
	
	template <class TSerializableObject> void SerializableObject::decodeObjectArray(std::vector<TSmartPtr<TSerializableObject> >& oArray, NSCoder* aDecoder, NSString* iKey)
	{
		decodeObjectArray((std::vector<P_SerializableObject>&) oArray, aDecoder, iKey);
	}
}

#endif // _SerializableObject_H_