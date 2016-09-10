//
//  Gesture3D.mm
//  Toolbox
//
//  Created by Gérald Guyomard on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Gesture3D.h"
#import "GLView.h"

using namespace Toolbox;

@implementation Gesture3D

@synthesize moveThreshold = _MoveThreshold;
@synthesize hasMoved = _HasMoved;

-(id) initWithGLView:(GLView*) iView
{
	if (self = [super init])
	{
		_GLView = iView;
		_HasMoved = NO;
		self.moveThreshold = kDefaultMoveThreshold;
	}
	
	return self;
}

-(BOOL) touchesbegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (nil == _TouchBegan)
	{
		TB_ASSERT(!_HasMoved);
		
		_TouchBeganTime = ::CFAbsoluteTimeGetCurrent();
		_TouchBegan = [touches anyObject];
		TB_ASSERT(nil != _TouchBegan);
		
		_InitialTouchLocation = [_TouchBegan locationInView:_GLView];
	}
	else
	{
		_TouchBegan = nil;
		_HasMoved = NO;
	}
	
	return NO;
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{	
	if ((nil != _TouchBegan) && [touches containsObject:_TouchBegan])
	{
		Vector2f loc = [_TouchBegan locationInView:_GLView];
		const Float32 sqrDist = (loc - _InitialTouchLocation).squareLength();
		if (sqrDist > _MoveThreshold * _MoveThreshold)
		{
			_HasMoved = YES;
		}
	}
	else
	{
		// A complex gesture is being done
		// discard tracking
		_TouchBegan = nil;
		_HasMoved = NO;
	}
}

-(BOOL) isLongStillTouch
{
	if (_HasMoved)
	{
		return NO;
	}
	
	const CFAbsoluteTime t = ::CFAbsoluteTimeGetCurrent();
	return (t - _TouchBeganTime) > 0.1;
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
}

@end

@implementation NodeGesture3D

-(id) initWithGLView:(GLView*)iView andNode3D:(Toolbox::Node3D&)iNode3D
{
	if (self = [super initWithGLView:iView])
	{
		_Target = iNode3D;
		_Type = eNoNG;
	}
	
	return self;
}

-(BOOL) touchesbegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesbegan:touches withEvent:event];
	
	_Type = eNoNG;
	
	return NO;
}

@end
