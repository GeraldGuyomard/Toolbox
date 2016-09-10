/*
 *  Box3D.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Box3D.h"
#include <OpenGLES/ES1/gl.h>
#import "GLTools.h"
#import "Ray3D.h"
#import "BoxGesture3D.h"

namespace Toolbox
{
	
Box3D::Box3D(const AABoxf& iBox)
: _Box(iBox)
{
	_Box.vertices(_Vertices);
}

Box3D::Box3D(const Box3D& iOther)
: SuperClass(iOther), _Box(iOther._Box)
{
	_Box.vertices(_Vertices);
}

// From Node3D
void Box3D::_selfClone(P_Node3D& oClone) const
{
	oClone = new Box3D(*this);
}
	
void
Box3D::_localBox(AABoxf& oBox) const
{
	oBox = _Box;
}

bool
Box3D::_selfPick(const Ray3D& iRay, float& oCoeff) const
{
	return iRay.intersectsWith(_Box, &oCoeff);
}
	
void
Box3D::setBox(const AABoxf& iBox)
{
	if (iBox != _Box)
	{
		_Box = iBox;
		_Box.vertices(_Vertices);
		
		invalidateTransformCaches();
	}
}

void
Box3D::_render(RenderOptions& ioOptions)
{
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_LIGHTING);	
	assertIfGLFailed();
	
	glColor4ub(200, 0, 0, 255);
	glLineWidth(2.5f);
	
	glVertexPointer(3, GL_FLOAT, 0, (const Float32*) vertices());
	glEnableClientState (GL_VERTEX_ARRAY);
	
	static GLbyte indices1[4] = { 0, 1, 2, 3 };
	glDrawElements(GL_LINE_LOOP, 4, GL_UNSIGNED_BYTE, indices1);
	
	static GLbyte indices2[4] = { 4, 5, 6, 7 };
	glDrawElements(GL_LINE_LOOP, 4, GL_UNSIGNED_BYTE, indices2);
	
	static GLbyte indices3[8] = {0, 4, 5, 1, 2, 6, 7, 3 };
	glDrawElements(GL_LINES, 8, GL_UNSIGNED_BYTE, indices3);	
}

NodeGesture3D*
Box3D::gestureFromPick(const Ray3D& iGlobalRay, GLView* iGLView)
{
	if (!iGlobalRay.intersectsWith(globalBox()))
	{
		return nil;
	}
	
	Ray3D localRay;
	globalToLocal(iGlobalRay, localRay);
	
	return [BoxGesture3D boxGestureWithGLView:iGLView andBox3D:*this];
}
	
static NSString* const kBoxKey = @"Box";
	
void Box3D::_encode(NSCoder* aCoder)
{
	SuperClass::_encode(aCoder);
	
	encodePod(_Box, aCoder, kBoxKey);
}
	
void Box3D::_decode(NSCoder* aDecoder)
{
	SuperClass::_decode(aDecoder);
	
	decodePod(_Box, aDecoder, kBoxKey);
	
	_Box.vertices(_Vertices);
}

	
} // End of toolbox