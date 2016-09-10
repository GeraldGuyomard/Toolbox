/*
 *  Plane3D.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Plane3D_H_)
#define _Plane3D_H_

#include "Vector3f.h"

namespace Toolbox
{
	class Matrix44f;
	
	class Plane3D
	{
	public:
		Vector3f	normal;
		Float32 	d;
		
	public:
		
		Plane3D& createWithNormalAndPoint(const Vector3f& iNormal, const Vector3f& iPoint);
		Plane3D& createWith3Points(const Vector3f& iP1, const Vector3f& iP2, const Vector3f& iP3);
		
		// == 0 on plane, < 0 behind, > 0 in front of
		float position(const Vector3f& iPoint) const;
		bool contains(const Vector3f& iPoint) const;
		
		void transformBy(const Matrix44f& iMatrix, Plane3D& oPlane) const;
	};
	

	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline float Plane3D::position(const Vector3f& iPoint) const
	{
		return (normal * iPoint) + d;
	}
	
	inline bool Plane3D::contains(const Vector3f& iPoint) const
	{
		return isNearZero(position(iPoint));
	}
}

#endif // _Plane3D_H_