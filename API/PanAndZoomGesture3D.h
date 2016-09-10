//
//  Gesture3D.h
//  Toolbox
//
//  Created by Gérald Guyomard on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "Gesture3D.h"
#import <vector>
#import "Camera3D.h"

@interface PanAndZoomGesture3D : Gesture3D
{
@protected
	std::vector<Toolbox::P_Camera3D> _Cameras;
}

+(id) panAndZoomGestureWithGLView:(GLView*)iGLView;

-(void) addCamera:(Toolbox::Camera3D*)iCamera;

@end

