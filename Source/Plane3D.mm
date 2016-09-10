/*
 *  Plane3D.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Plane3D.h"
#include "Matrix44f.h"
#include "Vector4f.h"

namespace Toolbox
{
Plane3D&
Plane3D::createWithNormalAndPoint(const Vector3f& iNormal, const Vector3f& iPoint)
{
	TB_ASSERT(!iNormal.isNull());
	
	normal = iNormal;
	d		= -(iNormal * iPoint);
	
	return *this;
}
	
Plane3D&
Plane3D::createWith3Points(const Vector3f& iP1, const Vector3f& iP2, const Vector3f& iP3)
{
	Vector3f v1 = iP2 - iP1;
	Vector3f v2 = iP3 - iP1;	
	Vector3f n = v1 ^ v2;
	
	return createWithNormalAndPoint(n, iP1);
}

void
Plane3D::transformBy(const Matrix44f& iMatrix, Plane3D& oPlane) const
{
	Matrix44f inv;
	iMatrix.inverseAffine(inv);
	Matrix44f transpose;
	inv.transpose(transpose);
	
	transpose.transform((const Vector4f&) oPlane, (Vector4f&) oPlane);
}
	
} // End of toolbox