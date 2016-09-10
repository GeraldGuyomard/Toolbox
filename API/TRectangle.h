/*
 *  TRectangle.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_TRectangle_H_)
#define _TRectangle_H_

#include "TVector2.h"
#import <CoreGraphics/CGGeometry.h>

namespace Toolbox
{
	template <typename TScalar> class TRectangle
	{
	public:
		TVector2<TScalar>	origin;
		TVector2<TScalar> 	size;
		
	public:
		
		static const TRectangle kNull;
		static const TRectangle kUnit;
				
		// Constructors
		TRectangle();
		TRectangle(const TVector2<TScalar>& iOrigin, const TVector2<TScalar>& iSize);
		TRectangle(const TRectangle& iOther);
		TRectangle(const CGRect& iOther);
		
		void setCoordinates(const TVector2<TScalar>& iOrigin, const TVector2<TScalar>& iSize);
		void setEmpty();
		
		void add(const TVector2<TScalar>& iPoint);
		bool isEmpty() const;
		
		bool operator==(const TRectangle& iOther) const;
		bool operator!=(const TRectangle& iOther) const;
		bool equals(const TRectangle& iOther, TScalar iEpsilon = TConstants<TScalar>::kDefaultEpsilon) const;
		
		void moveToOrigin();
		TRectangle<TScalar>& translate(const TVector2<TScalar>& iOffset);
		TRectangle<TScalar>& scale(const TVector2<TScalar>& iScale);
	};
		
	typedef TRectangle<Int32> Rectanglei;
	typedef TRectangle<Float32> Rectanglef;
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	template <class TScalar> inline TRectangle<TScalar>::TRectangle()
	{}
	
	template <class TScalar> inline TRectangle<TScalar>::TRectangle(const TVector2<TScalar>& iOrigin, const TVector2<TScalar>& iSize)
	: origin(iOrigin), size(iSize)
	{}
	
	template <class TScalar> inline TRectangle<TScalar>::TRectangle(const TRectangle& iOther)
	: origin(iOther.origin), size(iOther.size)
	{}
	
	template <class TScalar> inline TRectangle<TScalar>::TRectangle(const CGRect& iOther)
	: origin(iOther.origin), size(iOther.size)
	{}
	
	template <class TScalar> inline void TRectangle<TScalar>::setCoordinates(const TVector2<TScalar>& iOrigin, const TVector2<TScalar>& iSize)
	{
		origin = iOrigin;
		size = iSize;
	}
	
	template <class TScalar> inline void TRectangle<TScalar>::setEmpty()
	{
		origin.setCoordinates(0, 0);
		size.setCoordinates(-1, -1);
	}
	
	template <class TScalar> void TRectangle<TScalar>::add(const TVector2<TScalar>& iPoint)
	{
		if (isEmpty())
		{
			origin = iPoint;
			size.setCoordinates(0, 0);
		}
		else
		{
			TVector2<TScalar> delta = iPoint - origin;
			
			if (delta.x < 0)
			{
				origin.x = iPoint.x;
				size.x -= delta.x;
			}
			else if (delta.x > size.x)
			{
				size.x = delta.x;
			}
			
			if (delta.y < 0)
			{
				origin.y = iPoint.y;
				size.y -= delta.y;
			}
			else if (delta.y > size.y)
			{
				size.y = delta.y;
			}
		}
	}
	
	template <class TScalar> bool TRectangle<TScalar>::isEmpty() const
	{
		return (size.x < 0) || (size.y < 0);
	}
	
	template <class TScalar> inline bool TRectangle<TScalar>::operator==(const TRectangle& iOther) const
	{
		return (origin == iOther.origin) && (size == iOther.size);
	}
	
	template <class TScalar> inline bool TRectangle<TScalar>::operator!=(const TRectangle& iOther) const
	{
		return (origin != iOther.origin) || (size != iOther.size);
	}
	
	template <class TScalar> inline bool TRectangle<TScalar>::equals(const TRectangle& iOther, TScalar iEpsilon) const
	{
		return origin.equals(iOther.origin, iEpsilon) && size.equals(iOther.size, iEpsilon);
	}
	
	template <class TScalar> inline void TRectangle<TScalar>::moveToOrigin()
	{
		origin = TVector2<TScalar>::kNull;	
	}
	
	template <class TScalar> TRectangle<TScalar>& TRectangle<TScalar>::translate(const TVector2<TScalar>& iOffset)
	{
		origin += iOffset;
		return *this;
	}
	
	template <class TScalar> TRectangle<TScalar>& TRectangle<TScalar>::scale(const TVector2<TScalar>& iScale)
	{
		origin.scale(iScale);
		size.scale(iScale);
		return *this;
	}
	
}

#endif // _TRectangle_H_