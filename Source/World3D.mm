/*
 *  World3D.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "World3D.h"
#include "Camera3D.h"

#include <OpenGLES/ES1/gl.h>

namespace Toolbox
{

World3D::World3D()
: _Root(new Node3D)
{
}
	
void
World3D::render(Camera3D& iCamera, const Vector2f& iViewportSize, RenderOptions& ioOptions)
{
	iCamera.setActive(iViewportSize);
	
	glEnable(GL_DEPTH_TEST);
	_Root->render(ioOptions);
}
	
static NSString* const kRootKey = @"Root";
	
void
World3D::_encode(NSCoder* aCoder)
{
	SuperClass::_encode(aCoder);
	
	SerializableObject::encode(_Root, aCoder, kRootKey);
}
	
void
World3D::_decode(NSCoder* aDecoder)
{
	SuperClass::_decode(aDecoder);
	
	SerializableObject::decode(_Root, aDecoder, kRootKey);
}
	
} // End of toolbox