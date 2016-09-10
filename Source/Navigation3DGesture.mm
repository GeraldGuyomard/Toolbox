//
//  NavigationGesture3D.mm
//  Toolbox
//
//  Created by Gérald Guyomard on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Navigation3DGesture.h"
#import "GLView.h"

using namespace Toolbox;

@implementation Navigation3DGesture

@synthesize targetPosition=_TargetPosition;
@synthesize landscapeMode = _LandscapeMode;

+(id) gestureWithGLView:(GLView*)iView andCamera:(Toolbox::Camera3D*)iCamera
{
	return [[[Navigation3DGesture alloc] initWithGLView:iView andCamera:iCamera] autorelease];
}

-(id) initWithGLView:(GLView*)iView andCamera:(Camera3D*)iCamera
{
	if (self = [super initWithGLView:iView])
	{
		_Camera = iCamera;
		_TargetPosition.clear();
	}
	
	return self;
}

-(void) orbitAround:(UITouch*)iTouch
{
	TB_ASSERT(nil != iTouch);
	
	//_LandscapeMode = YES;
	
	Vector2f delta = Vector2f([iTouch locationInView:_GLView]) - Vector2f([iTouch previousLocationInView:_GLView]);
	if (_LandscapeMode)
	{
		delta.setCoordinates(-delta.y, delta.x);
	}
	
	Matrix44f m = _Camera->localMatrix();
		
	Matrix44f viewMatrix;
	m.inverseAffine(viewMatrix);
	
	Vector3f localTarget;
	viewMatrix.transformPoint(_TargetPosition, localTarget);
		
	Vector3f viewUp = /*_LandscapeMode ? viewMatrix.right() :*/ viewMatrix.up();
	Float32 angleY = -delta.x * 0.01f;
	Matrix44f viewRotationY;
	viewRotationY.createRotation(angleY, viewUp, localTarget);
	m = viewRotationY * m;
	
	Float32 angleX = -delta.y * 0.01f;
	Matrix44f rotX;
	rotX.createRotation(angleX, _LandscapeMode ? Vector3f::kY : Vector3f::kX, localTarget);
	m = rotX * m;
	
	_Camera->setLocalMatrix(m);
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesMoved:touches withEvent:event];
	
	NSSet* allTouches = [event allTouches];
	const Uint32 touchCount = [allTouches count];
	
	if (touchCount == 2)
	{
		Vector2f prevLoc[2];
		Vector2f loc[2];
		Vector2f direction[2];		
		Uint32 i=0;
		for (UITouch* touch in allTouches)
		{
			prevLoc[i] = [touch previousLocationInView:_GLView];
			loc[i] = [touch locationInView:_GLView];
			direction[i++] = loc[i] - prevLoc[i];
		}
		
		TB_ASSERT(i == 2);
		
		if ((direction[0] * direction[1]) > 0)
		{
			// Pan
			Vector2f panDir = direction[0] * 0.1f;
			panDir.x = -panDir.x;
			_Camera->pan(panDir);
		}
		else
		{
			// Zoom
			Float32 prevDist = (prevLoc[1] - prevLoc[0]).length();
			Float32 dist = (loc[1] - loc[0]).length();
			
			Float32 f = (dist - prevDist) * -0.1f;
			_Camera->zoom(f);
		}
	}
	else if (touchCount == 1)
	{
		// Orbit
		[self orbitAround:[touches anyObject]];
	}
}

@end
