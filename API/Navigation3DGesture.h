//
//  NavigationGesture3D.h
//  Toolbox
//
//  Created by Gérald Guyomard on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Gesture3D.h"
#import "Camera3D.h"

@interface Navigation3DGesture : Gesture3D
{
@protected
	Toolbox::P_Camera3D _Camera;
	Toolbox::Vector3f	_TargetPosition;
	BOOL				_LandscapeMode;
}

@property(nonatomic, assign) Toolbox::Vector3f targetPosition;
@property(nonatomic, assign) BOOL landscapeMode;

+(id) gestureWithGLView:(GLView*)iView andCamera:(Toolbox::Camera3D*)iCamera;
-(id) initWithGLView:(GLView*)iView andCamera:(Toolbox::Camera3D*)iCamera;

@end