//
//  Gesture3D.h
//  Toolbox
//
//  Created by Gérald Guyomard on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node3D.h"
#import "Plane3D.h"
#import "Vector3f.h"
#import "TVector2.h"

@class GLView;

enum 
{
	kDefaultMoveThreshold = 8
};

// Base Class
@interface Gesture3D : NSObject
{
@protected
	GLView*	_GLView;
	
@private
	BOOL 				_HasMoved;
	Toolbox::Float32	_MoveThreshold;
	UITouch* 			_TouchBegan;
	CFAbsoluteTime		_TouchBeganTime;
	Toolbox::Vector2f	_InitialTouchLocation;
}

@property(nonatomic, assign) Float32 moveThreshold;
@property(nonatomic, readonly) BOOL hasMoved;

-(id) initWithGLView:(GLView*) iView;

-(BOOL) touchesbegan:(NSSet*)touches withEvent:(UIEvent*)event;
-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;

-(BOOL) isLongStillTouch;

@end

enum ENodeGestureType
{
	eNoNG = 0,
	
	eTranslateNode3D,
	
	eNodeGestureTypeCount
};

// Gestures working on a particular node
@interface NodeGesture3D : Gesture3D
{
@protected
	Toolbox::P_Node3D 	_Target;
	
	Toolbox::Uint32		_Type;
	Toolbox::Plane3D	_WorkingPlane;
	Toolbox::Vector3f	_InitialHitPoint;
	Toolbox::Vector3f	_InitialPosition;
}

-(id) initWithGLView:(GLView*)iView andNode3D:(Toolbox::Node3D&)iNode3D;

@end
