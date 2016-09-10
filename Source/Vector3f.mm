/*
 *  Vector3.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Vector3f.h"

namespace Toolbox
{
	
const Vector3f Vector3f::kNull(0.f, 0.f, 0.f);
const Vector3f Vector3f::kX(1.f, 0.f, 0.f);
const Vector3f Vector3f::kY(0.f, 1.f, 0.f);
const Vector3f Vector3f::kZ(0.f, 0.f, 1.f);
	
Vector3f
Vector3f::interpolate(const Vector3f& iV1, const Vector3f& iV2, Float32 iCoeff)
{
	Vector3f v;
	
	const Float32 c = 1.f - iCoeff;
	
	v.x = (iV1.x * c) + (iV2.x * iCoeff);
	v.y = (iV1.y * c) + (iV2.y * iCoeff);
	v.z = (iV1.z * c) + (iV2.z * iCoeff);
	
	return v;
}

Vector3f
Vector3f::pInterpolate(const Vector3f& iV1, const Vector3f& iV2, Float32 iCoeff)
{
	TB_ASSERT(iV1.z != 0.f);
	TB_ASSERT(iV2.z != 0.f);
	
	Vector3f v;
	
	const Float32 c = 1.f - iCoeff;
	const Float32 invZ1 = 1.f / iV1.z;
	const Float32 invZ2 = 1.f / iV2.z;
	
	// Linear interpolation of 1/z
	Float32 invZ = (c * invZ1) + (iCoeff * invZ2);
	
	// Linear interpolation of (x/z, y/z, z/z)
	Float32 xDivZ = (c * iV1.x * invZ1) + (iCoeff * iV2.x * invZ2);
	Float32 yDivZ = (c * iV1.y * invZ1) + (iCoeff * iV2.y * invZ2);
	//Float32 xDivZ = (c * iV1.x * invZ) + (iCoeff * iV2.x * invZ);
	//Float32 yDivZ = (c * iV1.y * invZ) + (iCoeff * iV2.y * invZ);
	
	Float32 z = 1.f / invZ;
	
	v.x = xDivZ * z;
	v.y = yDivZ * z;
	v.z = z;
	
	return v;
}
	
} // End of toolbox