/*
 *  Ray3D.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Ray3D.h"
#include "Matrix44f.h"
#include "AABoxf.h"
#include "Plane3D.h"

namespace Toolbox
{

const Ray3D Ray3D::kNull = Ray3D().createWith2Points(Vector3f::kNull, Vector3f::kNull);

void Ray3D::setDirection(const Vector3f& iDirection)
{
	_NormalizedDirection = iDirection;
	if (!iDirection.isNull())
	{
		_NormalizedDirection.normalize();	
	}
}
	
void Ray3D::transformBy(const Matrix44f& iMatrix, Ray3D& oRay) const
{
	iMatrix.transformPoint(_Origin, oRay._Origin);
	iMatrix.affineTransformVector(_NormalizedDirection, oRay._NormalizedDirection);
	oRay._NormalizedDirection.normalize();
}

bool Ray3D::intersectsWith(const AABoxf& iBox, Float32* oMinCoeff, Float32* oMaxCoeff) const
{
	TB_ASSERT(!isNull());
	
	// Old fashioned Smits's method
	// see http://people.csail.mit.edu/amy//papers/box-jgt.pdf
	// for optimized ray / AABB intersection if many boxes involved
	
	
	// First of all, deal with ray parallel to axis
	for (Uint32 i=0; i < eAxisCount; ++i)
	{
		EAxis axis = (EAxis) i;
		
		if (isNearZero(_NormalizedDirection[axis]))
		{
			if ((_Origin[axis] <= iBox.minCorner[axis]) || (_Origin[axis] >= iBox.maxCorner[axis]))
			{
				return false;
			}
		}
	}
	
	// X	
	Float32 tmin = (iBox.minCorner.x - _Origin.x) / _NormalizedDirection.x;
	Float32 tmax = (iBox.maxCorner.x - _Origin.x) / _NormalizedDirection.x;
	
	if (_NormalizedDirection.x < 0.f)
	{
		TB_ASSERT(tmin >= tmax);
		std::swap(tmin, tmax);
	}
	
	TB_ASSERT(tmin < tmax);
	
	Float32 tymin = (iBox.minCorner.y - _Origin.y) / _NormalizedDirection.y;
	Float32 tymax = (iBox.maxCorner.y - _Origin.y) / _NormalizedDirection.y;
	
	if (_NormalizedDirection.y < 0.f)
	{
		TB_ASSERT(tymin > tymax);
		std::swap(tymin, tymax);
	}
	
	TB_ASSERT(tymin < tymax);
	
	if (tymin > tmin)
	{
		tmin = tymin;	
	}
	
	if (tymax < tmax)
	{
		tmax = tymax;
	}
	
	if (tmin > tmax)
	{
		return false;
	}
	

	Float32 tzmin = (iBox.minCorner.z - _Origin.z) / _NormalizedDirection.z;
	Float32 tzmax = (iBox.maxCorner.z - _Origin.z) / _NormalizedDirection.z;
	if (_NormalizedDirection.z < 0.f)
	{
		TB_ASSERT(tzmin > tzmax);
		std::swap(tzmin, tzmax);
	}
	
	TB_ASSERT(tzmin < tzmax);
	
	if (tzmin > tmin)
	{
		tmin = tzmin;
	}
	
	if (tzmax < tmax)
	{
		tmax = tzmax;
	}
	
	if (tmin > tmax)
	{
		return false;
	}

	TB_ASSERT(tmin <= tmax);
	
	if (tmin >= 0.f)
	{
		if (NULL != oMinCoeff)
		{
			*oMinCoeff = tmin;
		}

		if (NULL != oMaxCoeff)
		{
			*oMaxCoeff = tmax;
		}
		
		return true;
	}
	
	return false;
}

bool Ray3D::intersectsWith(const Plane3D& iPlane, Float32* oCoeff) const
{
	const Float32 rayDirDotPlaneNormal = _NormalizedDirection * iPlane.normal;
	if (isNearZero(rayDirDotPlaneNormal))
	{
		// Parallel or contained
		return false;
	}
	
	if (NULL != oCoeff)
	{
		*oCoeff = -(iPlane.d + (_Origin * iPlane.normal)) / rayDirDotPlaneNormal;
	}
	
	return true;
}

Int32 Ray3D::intersectedPlane(const AABoxf& iBox, Vector3f* oPoint) const
{
	Plane3D localPlanes[AABoxf::ePlaneCount];
	iBox.planes(localPlanes);
	
	Float32 minCoeff = FLT_MAX;
	Int32 planeIndex = -1;
	
	for (Uint32 i=0; i < AABoxf::ePlaneCount; ++i)
	{
		Float32 coeff;
		if (intersectsWith(localPlanes[i], &coeff) && (coeff < minCoeff))
		{
			Vector3f point = pointAt(coeff);
			if (iBox.contains(point))
			{
				minCoeff = coeff;
				planeIndex = i;		
			}
		}
	}
	
	if ((NULL != oPoint) && (planeIndex >= 0))
	{
		*oPoint = pointAt(minCoeff);		
	}
		
	return planeIndex;
}
	
} // End of toolbox