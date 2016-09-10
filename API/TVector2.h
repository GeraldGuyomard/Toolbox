/*
 *  TVector2.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_TVector2_H_)
#define _TVector2_H_

#include "BasicTypes.h"
#include "MathTools.h"
#import <CoreGraphics/CGGeometry.h>

namespace Toolbox
{
	template <typename TScalar> class TVector2
	{
	public:
		TScalar	x;
		TScalar y;
		
	public:
		
		static const TVector2 kNull;
		static const TVector2 kUnit;
				
		// Constructors
		TVector2();
		TVector2(TScalar iX, TScalar iY);
		TVector2(const TVector2& iOther);
		
		template <typename U> TVector2(const TVector2<U>& iOther)
		: x(TScalar(iOther.x)), y(TScalar(iOther.y))
		{}
		
		TVector2(const CGSize& iSize);
		TVector2(const CGPoint& iPoint);
		
		operator CGSize() const;
		operator CGPoint() const;
		
		void clear();
		void setCoordinates(TScalar iX, TScalar iY);
		
		Float32 squareLength() const;
		Float32 length() const;
		void normalize();
		
		TVector2 operator-() const;
		
		TVector2& operator*=(TScalar iScalar);
		TVector2& operator/=(TScalar iScalar);
		
		TVector2& operator+=(const TVector2& iOther);
		TVector2& operator-=(const TVector2& iOther);
		
		bool operator==(const TVector2& iOther) const;
		bool operator!=(const TVector2& iOther) const;
		bool equals(const TVector2& iOther, TScalar iEpsilon=TConstants<TScalar>::kDefaultEpsilon) const;
		
		TVector2<TScalar>& scale(const TVector2<TScalar>& iScale);
		
		// Distance between point and segment
		static bool distance(const TVector2& iSegmentStart, const TVector2& iSegmentEnd, const TVector2& iExternalPoint, float& oDistance);
		static bool squareDistance(const TVector2& iSegmentStart, const TVector2& iSegmentEnd, const TVector2& iExternalPoint, float& oDistance);
	};
	
	// Global Operators
	template <typename TScalar> TScalar operator*(const TVector2<TScalar>& iV1, const TVector2<TScalar>& iV2); // Dot Product
	template <typename TScalar> TVector2<TScalar> operator*(const TVector2<TScalar>& iV1, TScalar iScalar);
	template <typename TScalar> TVector2<TScalar> operator/(const TVector2<TScalar>& iV1, TScalar iScalar);
	
	template <typename TScalar> TVector2<TScalar> operator+(const TVector2<TScalar>& iV1, const TVector2<TScalar>& iV2);
	template <typename TScalar> TVector2<TScalar> operator-(const TVector2<TScalar>& iV1, const TVector2<TScalar>& iV2);
	
	typedef TVector2<Int32> Vector2i;
	typedef TVector2<Float32> Vector2f;
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	template <typename TScalar> inline TVector2<TScalar>::TVector2()
	{}
	
	template <typename TScalar> inline TVector2<TScalar>::TVector2(TScalar iX, TScalar iY)
	: x(iX), y(iY) {}

	template <typename TScalar> inline TVector2<TScalar>::TVector2(const TVector2& iOther)
	: x(iOther.x), y(iOther.y) {}
	
	template <typename TScalar> inline TVector2<TScalar>::TVector2(const CGSize& iSize)
	: x(iSize.width), y(iSize.height)  {}

	template <typename TScalar> inline TVector2<TScalar>::TVector2(const CGPoint& iPoint)
	: x(iPoint.x), y(iPoint.y)  {}
	
	template <typename TScalar> inline void TVector2<TScalar>::clear()
	{
		x = y = TScalar(0);
	}
	
	template <typename TScalar> inline TVector2<TScalar>::operator CGSize() const
	{
		return CGSizeMake(x, y);
	}

	template <typename TScalar> inline TVector2<TScalar>::operator CGPoint() const
	{
		return CGPointMake(x, y);
	}
	
	template <typename TScalar> inline void TVector2<TScalar>::setCoordinates(TScalar iX, TScalar iY)
	{
		x = iX;
		y = iY;
	}
	
	template <typename TScalar> inline Float32 TVector2<TScalar>::squareLength() const
	{
		return (x * x) + (y * y);		
	}

	template <typename TScalar> inline Float32 TVector2<TScalar>::length() const
	{
		return sqrtf((Float32) squareLength());
	}
	
	template <typename TScalar> inline void TVector2<TScalar>::normalize()
	{
		const Float32 l = length();
		TB_ASSERT(l != 0);
		const Float32 invLength = 1.f / l;
		x *= invLength;
		y *= invLength;
	}
	
	template <typename TScalar> inline TVector2<TScalar> TVector2<TScalar>::operator-() const
	{
		return TVector2(-x, -y);
	}
	
	template <typename TScalar> inline TVector2<TScalar>& TVector2<TScalar>::operator*=(TScalar iScalar)
	{
		x *= iScalar;
		y *= iScalar;
		
		return *this;
	}

	template <typename TScalar> inline TVector2<TScalar>& TVector2<TScalar>::operator/=(TScalar iScalar)
	{
		TB_ASSERT(iScalar != 0.f);
		x /= iScalar;
		y /= iScalar;
		
		return *this;
	}
	
	template <typename TScalar> inline TVector2<TScalar>& TVector2<TScalar>::operator+=(const TVector2<TScalar>& iOther)
	{
		x += iOther.x;
		y += iOther.y;
		
		return *this;
	}

	template <typename TScalar> inline TVector2<TScalar>& TVector2<TScalar>::operator-=(const TVector2<TScalar>& iOther)
	{
		x -= iOther.x;
		y -= iOther.y;
		
		return *this;
	}
	
	template <typename TScalar> inline TScalar operator*(const TVector2<TScalar>& iV1, const TVector2<TScalar>& iV2)
	{
		return (iV1.x * iV2.x) + (iV1.y * iV2.y);
	}
	
	template <typename TScalar> TVector2<TScalar> inline operator*(const TVector2<TScalar>& iV1, TScalar iScalar)
	{
		return TVector2<TScalar>(iV1.x * iScalar, iV1.y * iScalar);	
	}

	template <typename TScalar> TVector2<TScalar> inline operator/(const TVector2<TScalar>& iV1, TScalar iScalar)
	{
		TB_ASSERT(iScalar != 0.f);
		return TVector2<TScalar>(iV1.x / iScalar, iV1.y / iScalar);	
	}
	
	template <typename TScalar> inline bool TVector2<TScalar>::operator==(const TVector2& iOther) const
	{
		return (x == iOther.x) && (y == iOther.y);
	}

	template <typename TScalar> inline bool TVector2<TScalar>::operator!=(const TVector2& iOther) const
	{
		return (x != iOther.x) || (y != iOther.y);
	}
	
	template <typename TScalar> bool TVector2<TScalar>::equals(const TVector2& iOther, TScalar iEpsilon) const
	{
		return isNearValue(x, iOther.x, iEpsilon) && isNearValue(y, iOther.y, iEpsilon);
	}
	
	template <typename TScalar> inline TVector2<TScalar> operator+(const TVector2<TScalar>& iV1, const TVector2<TScalar>& iV2)
	{
		return TVector2<TScalar>(iV1.x + iV2.x, iV1.y + iV2.y);
	}

	template <typename TScalar> inline TVector2<TScalar> operator-(const TVector2<TScalar>& iV1, const TVector2<TScalar>& iV2)
	{
		return TVector2<TScalar>(iV1.x - iV2.x, iV1.y - iV2.y);
	}
	
	template <typename TScalar> inline TVector2<TScalar>& TVector2<TScalar>::scale(const TVector2<TScalar>& iScale)
	{
		x *= iScale.x;
		y *= iScale.y;
		
		return *this;
	}
	
	template <typename TScalar> inline bool TVector2<TScalar>::squareDistance(const TVector2& iSegmentStart, const TVector2& iSegmentEnd, const TVector2& iExternalPoint, float& oDistance)
	{
		TVector2 segment = iSegmentEnd - iSegmentStart;
		if (segment == TVector2::kNull)
		{
			return false;
		}
		
		TVector2 segmentStartToExternalPoint = iExternalPoint - iSegmentStart;
		
		const float t = float(segmentStartToExternalPoint * segment) / float(segment.squareLength());
		if ((t < 0.f) || (t > 1.f))
		{
			return false;
		}
		
		float x = (t * float(segment.x)) + float(iSegmentStart.x); 
		float y = (t * float(segment.y)) + float(iSegmentStart.y);
		
		x -= iExternalPoint.x;
		y -= iExternalPoint.y;
		
		oDistance = (x * x) + (y * y);
		return true;
	}
	
	template <typename TScalar> inline bool TVector2<TScalar>::distance(const TVector2& iSegmentStart, const TVector2& iSegmentEnd, const TVector2& iExternalPoint, float& oDistance)
	{
		if (!squareDistance(iSegmentStart, iSegmentEnd, iExternalPoint, oDistance))
		{
			return false;
		}
		
		oDistance = sqrtf(oDistance);
		
		return true;
	}
}

#endif // _TVector2_H_