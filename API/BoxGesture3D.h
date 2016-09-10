//
//  Gesture3D.h
//  Toolbox
//
//  Created by Gérald Guyomard on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Gesture3D.h"

namespace Toolbox
{
	class Box3D;	
}

@interface BoxGesture3D : NodeGesture3D
{
@protected
	float _InitialHeight;
}

+(id) boxGestureWithGLView:(GLView*)iGLView andBox3D:(Toolbox::Box3D&)iBox3D;
-(id) initWithGLView:(GLView*)iView andBox3D:(Toolbox::Box3D&)iBox3D;

@end
