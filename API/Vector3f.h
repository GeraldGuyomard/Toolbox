/*
 *  Vector3f.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Vector3_H_)
#define _Vector3_H_

#include "BasicTypes.h"
#include "MathTools.h"
#include <limits>
#include <algorithm>

namespace Toolbox
{
	class Vector3f
	{
	public:
		Float32		x;
		Float32 	y;
		Float32 	z;
		
	public:
		
		static const Vector3f kNull;
		static const Vector3f kX;
		static const Vector3f kY;
		static const Vector3f kZ;
		
		static Vector3f interpolate(const Vector3f& iV1, const Vector3f& iV2, Float32 iCoeff);
		
		// Use z for perspective correct interpolation
		static Vector3f pInterpolate(const Vector3f& iV1, const Vector3f& iV2, Float32 iCoeff);
		
		// Constructors
		Vector3f();
		Vector3f(Float32 iX, Float32 iY, Float32 iZ);
		Vector3f(Float32 iValue);
		Vector3f(const Vector3f& iOther);
		
        bool isValid() const;
        
		void clear();
		void setCoordinates(Float32 iX, Float32 iY, Float32 iZ);
		
		Float32 squareLength() const;
		Float32 length() const;
		void normalize();
		bool isNormalized(Float32 iEpsilon=DEFAULT_EPSILON) const;
		bool isNull() const;
		
		Float32 maxDimension() const;
		EAxis maxDimensionAxis() const;
		
		Float32& operator[](EAxis iAxis);
		const Float32& operator[](EAxis iAxis) const;
		
		bool operator==(const Vector3f& iOther) const;
		bool operator!=(const Vector3f& iOther) const;
		bool equals(const Vector3f& iOther, Float32 iEpsilon=DEFAULT_EPSILON) const;
		
		Vector3f& operator*=(Float32 iScale);
		Vector3f& operator/=(Float32 iScale);
		
		Vector3f& operator+=(const Vector3f& iOther);
		Vector3f& operator-=(const Vector3f& iOther);
		
		Vector3f operator-() const;
	};
	
	// Global Operators
	Vector3f operator+(const Vector3f& iV1, const Vector3f& iV2);
	Vector3f operator-(const Vector3f& iV1, const Vector3f& iV2);
	
	Float32 operator*(const Vector3f& iV1, const Vector3f& iV2); // Dot Product
	Vector3f operator^(const Vector3f& iV1, const Vector3f& iV2); // Cross Product
	
	// Scale
	Vector3f operator*(const Vector3f& iVector, Float32 iScalar);
	Vector3f operator*(Float32 iScalar, const Vector3f& iVector);
	Vector3f operator/(const Vector3f& iVector, Float32 iScalar);
	Vector3f operator/(Float32 iScalar, const Vector3f& iVector);
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline Vector3f::Vector3f()
	{}
	
	inline Vector3f::Vector3f(Float32 iX, Float32 iY, Float32 iZ)
	: x(iX), y(iY), z(iZ) {}

	inline Vector3f::Vector3f(Float32 iValue)
	: x(iValue), y(iValue), z(iValue) {}
	
	inline Vector3f::Vector3f(const Vector3f& iOther)
	: x(iOther.x), y(iOther.y), z(iOther.z) {}
	
	inline void Vector3f::clear()
	{
		x = y = z = 0.f;
	}
	
	inline void Vector3f::setCoordinates(Float32 iX, Float32 iY, Float32 iZ)
	{
		x = iX;
		y = iY;
		z = iZ;
	}
	
    inline bool Vector3f::isValid() const
    {
        return !isnan(x) && !isnan(y) && !isnan(z);
    }
    
	inline Float32 Vector3f::squareLength() const
	{
		return (x * x) + (y * y) + (z * z);		
	}

	inline Float32 Vector3f::length() const
	{
		return sqrtf(squareLength());
	}
	
	inline void Vector3f::normalize()
	{
		const Float32 l = length();
		TB_ASSERT(l != 0);
		const Float32 invLength = 1.f / l;
		x *= invLength;
		y *= invLength;
		z *= invLength;
	}
	
	inline bool
	Vector3f::isNormalized(Float32 iEpsilon) const
	{
		return isNearValue(squareLength(), 1.f, iEpsilon * iEpsilon);
	}
	
	inline bool
	Vector3f::isNull() const
	{
		return isNearZero(x) && isNearZero(y) && isNearZero(z);
	}
	
	inline Float32 Vector3f::maxDimension() const
	{
		const Float32 absX = fabsf(x);
		const Float32 absY = fabsf(y);
		const Float32 absZ = fabsf(z);
		
		if (absX >= absY)
		{
			return std::max(absX, absZ);	
		}
		else
		{
			return std::max(absY, absZ);
		}
	}

	inline EAxis Vector3f::maxDimensionAxis() const
	{
		const Float32 absX = fabsf(x);
		const Float32 absY = fabsf(y);
		const Float32 absZ = fabsf(z);
		
		if (absX >= absY)
		{
			if (absX >= absZ)
			{
				return eX;
			}
			else
			{
				return eZ;
			}
		}
		else
		{
			if (absY >= absZ)
			{
				return eY;
			}
			else
			{
				return eZ;
			}
		}
	}
	
	inline Float32& Vector3f::operator[](EAxis iAxis)
	{
		return ((Float32*) this)[iAxis];
	}
	
	inline const Float32& Vector3f::operator[](EAxis iAxis) const
	{
		return ((const Float32*) this)[iAxis];
	}
	
	inline bool Vector3f::operator==(const Vector3f& iOther) const
	{
		return (x == iOther.x) && (y == iOther.y) && (z == iOther.z);
	}

	inline bool Vector3f::equals(const Vector3f& iOther, Float32 iEpsilon) const
	{
		return isNearValue(x, iOther.x, iEpsilon) && isNearValue(y, iOther.y, iEpsilon)	&& isNearValue(z, iOther.z, iEpsilon);
	}
	
	inline bool Vector3f::operator!=(const Vector3f& iOther) const
	{
		return (x != iOther.x) || (y != iOther.y) || (z != iOther.z);
	}
	
	inline Vector3f& Vector3f::operator*=(Float32 iScale)
	{
		x *= iScale;
		y *= iScale;
		z *= iScale;
		
		return *this;
	}
	
	inline Vector3f& Vector3f::operator/=(Float32 iScale)
	{
		TB_ASSERT(iScale != 0.f);
		x /= iScale;
		y /= iScale;
		z /= iScale;
		
		return *this;		
	}
	
	inline Vector3f& Vector3f::operator+=(const Vector3f& iOther)
	{
		x += iOther.x;
		y += iOther.y;
		z += iOther.z;
		
		return *this;
	}
	
	inline Vector3f& Vector3f::operator-=(const Vector3f& iOther)
	{
		x -= iOther.x;
		y -= iOther.y;
		z -= iOther.z;
		
		return *this;
	}
	
	inline Vector3f Vector3f::operator-() const
	{
		return Vector3f(-x, -y, -z);
	}
	
	inline Vector3f operator+(const Vector3f& iV1, const Vector3f& iV2)
	{
		return Vector3f(iV1.x + iV2.x, iV1.y + iV2.y, iV1.z + iV2.z);
	}

	inline Vector3f operator-(const Vector3f& iV1, const Vector3f& iV2)
	{
		return Vector3f(iV1.x - iV2.x, iV1.y - iV2.y, iV1.z - iV2.z);
	}
	
	inline Float32 operator*(const Vector3f& iV1, const Vector3f& iV2)
	{
		return (iV1.x * iV2.x) + (iV1.y * iV2.y) + (iV1.z * iV2.z);
	}
	
	inline Vector3f operator^(const Vector3f& iV1, const Vector3f& iV2)
	{
		Vector3f crossV;
		
		// (a2b3 − a3b2, a3b1 − a1b3, a1b2 − a2b1).
		crossV.x = (iV1.y * iV2.z) - (iV1.z * iV2.y);
		crossV.y = (iV1.z * iV2.x) - (iV1.x * iV2.z);
		crossV.z = (iV1.x * iV2.y) - (iV1.y * iV2.x);
		
		return crossV;
	}
	
	inline Vector3f operator*(const Vector3f& iVector, Float32 iScalar)
	{
		return Vector3f(iVector.x * iScalar, iVector.y * iScalar, iVector.z * iScalar);	
	}
	
	inline Vector3f operator*(Float32 iScalar, const Vector3f& iVector)
	{
		return Vector3f(iVector.x * iScalar, iVector.y * iScalar, iVector.z * iScalar);
	}

	inline Vector3f operator/(const Vector3f& iVector, Float32 iScalar)
	{
		TB_ASSERT(iScalar != 0);
		return Vector3f(iVector.x / iScalar, iVector.y / iScalar, iVector.z / iScalar);	
	}
	
	inline Vector3f operator/(Float32 iScalar, const Vector3f& iVector)
	{
		TB_ASSERT(iScalar != 0);
		return Vector3f(iVector.x / iScalar, iVector.y / iScalar, iVector.z / iScalar);
	}
}

#endif // _Vector3f_H_
