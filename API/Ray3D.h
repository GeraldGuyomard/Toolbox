/*
 *  Ray3D.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Ray3D_H_)
#define _Ray3D_H_

#include "Vector3f.h"

namespace Toolbox
{
	class Matrix44f;
	class AABoxf;
	class Plane3D;
	
	class Ray3D
	{
	public:
		static const Ray3D kNull;
		
		bool isNull() const;
		
		Ray3D& createWithDirection(const Vector3f& iOrigin, const Vector3f& iDirection);
		Ray3D& createWith2Points(const Vector3f& iOrigin, const Vector3f& iEnd);
		
		const Vector3f& origin() const;
		void setOrigin(const Vector3f& iOrigin);
		
		const Vector3f& normalizedDirection() const;
		void setDirection(const Vector3f& iDirection);
		void setNormalizedDirection(const Vector3f& iDirection);
		
		void transformBy(const Matrix44f& iMatrix, Ray3D& oRay) const;
		
		bool intersectsWith(const AABoxf& iBox, Float32* oMinCoeff = NULL, Float32* oMaxCoeff = NULL) const;
		Int32 intersectedPlane(const AABoxf& iBox, Vector3f* oPoint = NULL) const;
		
		bool intersectsWith(const Plane3D& iPlane, Float32* oCoeff = NULL) const;
		
		Vector3f pointAt(Float32 iCoeff) const;
		
	private:
		Vector3f _Origin;
		Vector3f _NormalizedDirection;
	};
	
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline const Vector3f&
	Ray3D::origin() const
	{
		return _Origin;
	}
	
	inline void
	Ray3D::setOrigin(const Vector3f& iOrigin)
	{
		_Origin = iOrigin;
	}
	
	inline const Vector3f&
	Ray3D::normalizedDirection() const
	{
		return _NormalizedDirection;	
	}
	
	inline void
	Ray3D::setNormalizedDirection(const Vector3f& iDirection)
	{
		TB_ASSERT(iDirection.isNormalized());
		_NormalizedDirection = iDirection;
	}
	
	inline bool
	Ray3D::isNull() const
	{
		return _NormalizedDirection.isNull();
	}
	
	inline Ray3D&
	Ray3D::createWithDirection(const Vector3f& iOrigin, const Vector3f& iDirection)
	{
		setOrigin(iOrigin);
		setDirection(iDirection);
		return *this;
	}
	
	inline Ray3D&
	Ray3D::createWith2Points(const Vector3f& iOrigin, const Vector3f& iEnd)
	{
		setOrigin(iOrigin);
		setDirection(iEnd - iOrigin);
		return *this;
	}
	
	inline Vector3f Ray3D::pointAt(Float32 iCoeff) const
	{
		return _Origin + (_NormalizedDirection * iCoeff);
	}
}

#endif // _Ray3D_H_