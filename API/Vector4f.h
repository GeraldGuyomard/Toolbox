/*
 *  Vector4f.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Vector4f_H_)
#define _Vector4f_H_

#include "BasicTypes.h"
#include "MathTools.h"
#include <limits>
#include <algorithm>
#include "Vector3f.h"

namespace Toolbox
{
	class Vector4f
	{
	public:
		Float32		x;
		Float32 	y;
		Float32 	z;
		Float32		w;
		
	public:
		
		static const Vector4f kNull;
		
		static Vector4f interpolate(const Vector4f& iV1, const Vector4f& iV2, Float32 iCoeff);
		
		// Constructors
		Vector4f();
		Vector4f(Float32 iX, Float32 iY, Float32 iZ, Float32 iW);
		Vector4f(const Vector4f& iOther);

		Vector4f& createFromPoint(const Vector3f& iPoint);
		Vector4f& createFromVector(const Vector3f& iVector);
		
		void setCoordinates(Float32 iX, Float32 iY, Float32 iZ, Float32 iW);
		
		bool isVector() const;
		bool isPoint() const;
		
		Float32 squareLength() const;
		Float32 length() const;
		void normalize();
		bool isNormalized(Float32 iEpsilon=DEFAULT_EPSILON) const;
		bool isNull() const;
		
		bool operator==(const Vector4f& iOther) const;
		bool operator!=(const Vector4f& iOther) const;
		
		Vector4f& operator+=(const Vector4f& iOther);
		Vector4f& operator-=(const Vector4f& iOther);
		
		Vector4f operator-() const;
	};
	
	// Global Operators
	Vector4f operator+(const Vector4f& iV1, const Vector4f& iV2);
	Vector4f operator-(const Vector4f& iV1, const Vector4f& iV2);
	
	Float32 operator*(const Vector4f& iV1, const Vector4f& iV2); // Dot Product
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline Vector4f::Vector4f()
	{}
	
	inline Vector4f::Vector4f(Float32 iX, Float32 iY, Float32 iZ, Float32 iW)
	: x(iX), y(iY), z(iZ), w(iW) {}
	
	inline Vector4f::Vector4f(const Vector4f& iOther)
	: x(iOther.x), y(iOther.y), z(iOther.z) {}
	
	inline void Vector4f::setCoordinates(Float32 iX, Float32 iY, Float32 iZ, Float32 iW)
	{
		x = iX;
		y = iY;
		z = iZ;
	}
	
	inline Vector4f& Vector4f::createFromPoint(const Vector3f& iPoint)
	{
		setCoordinates(iPoint.x, iPoint.y, iPoint.z, 1.f);
		return *this;	
	}
	
	inline Vector4f& Vector4f::createFromVector(const Vector3f& iVector)
	{
		setCoordinates(iVector.x, iVector.y, iVector.z, 0.f);
		return *this;		
	}
	
	inline bool
	Vector4f::isVector() const
	{
		return w == 0.f;
	}
	
	inline bool Vector4f::isPoint() const
	{
		return w != 0.f;
	}
	
	inline Float32 Vector4f::squareLength() const
	{
		return (x * x) + (y * y) + (z * z) + (w * w);		
	}

	inline Float32 Vector4f::length() const
	{
		return sqrtf(squareLength());
	}
	
	inline void Vector4f::normalize()
	{
		const Float32 l = length();
		TB_ASSERT(l != 0);
		const Float32 invLength = 1.f / l;
		x *= invLength;
		y *= invLength;
		z *= invLength;
		w *= invLength;
	}
	
	inline bool
	Vector4f::isNormalized(Float32 iEpsilon) const
	{
		return isNearValue(squareLength(), 1.f, iEpsilon * iEpsilon);
	}
	
	inline bool
	Vector4f::isNull() const
	{
		return isNearZero(x) && isNearZero(y) && isNearZero(z) && isNearZero(w);
	}
	
	inline bool Vector4f::operator==(const Vector4f& iOther) const
	{
		return (x == iOther.x) && (y == iOther.y) && (z == iOther.z) && (w == iOther.w);
	}

	inline bool Vector4f::operator!=(const Vector4f& iOther) const
	{
		return (x != iOther.x) || (y != iOther.y) || (z != iOther.z) || (w != iOther.w);
	}
	
	inline Vector4f& Vector4f::operator+=(const Vector4f& iOther)
	{
		x += iOther.x;
		y += iOther.y;
		z += iOther.z;
		w += iOther.w;
		
		return *this;
	}
	
	inline Vector4f& Vector4f::operator-=(const Vector4f& iOther)
	{
		x -= iOther.x;
		y -= iOther.y;
		z -= iOther.z;
		w -= iOther.w;
		
		return *this;
	}
	
	inline Vector4f Vector4f::operator-() const
	{
		return Vector4f(-x, -y, -z, -w);
	}
	
	inline Vector4f operator+(const Vector4f& iV1, const Vector4f& iV2)
	{
		return Vector4f(iV1.x + iV2.x, iV1.y + iV2.y, iV1.z + iV2.z, iV1.w + iV2.w);
	}

	inline Vector4f operator-(const Vector4f& iV1, const Vector4f& iV2)
	{
		return Vector4f(iV1.x - iV2.x, iV1.y - iV2.y, iV1.z - iV2.z, iV1.w - iV2.w);
	}
	
	inline Float32 operator*(const Vector4f& iV1, const Vector4f& iV2)
	{
		return (iV1.x * iV2.x) + (iV1.y * iV2.y) + (iV1.z * iV2.z) + (iV1.w * iV2.w);
	}
}

#endif // _Vector4f_H_