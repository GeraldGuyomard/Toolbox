/*
 *  TFaceRasterizer.h
 *  Toolbox
 *
 *  Created by Gougou on 11/08/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#if !defined(__TFaceRasterizer_H__)
#define __TFaceRasterizer_H__

#include "TVector2.h"
#include "Color.h"
#include "ImageRGBA8.h"
#include <vector>

namespace Toolbox
{

class ScannerInterface
{
public:
	void startUpperSubTriangle();
	void startLowerSubTriangle();
	
	void scan(Int32 iX, Int32 iY);
	
private:
	ScannerInterface() {};
};

class ColorScanner
{
public:
	ColorScanner(ImageRGBA8& oImage, const ColorRGBA8& iUpperColor, const ColorRGBA8& iLowerColor);

	void startUpperSubTriangle();
	void startLowerSubTriangle();
	
	void scan(Int32 iX, Int32 iY);
	
private:
	P_ImageRGBA8 _OutImage;
	ColorRGBA8 _OutColor;
	ColorRGBA8 _UpperColor;
	ColorRGBA8 _LowerColor;
};
	
template <class TScanner> class TFaceRasterizer
{
public:
	
	TFaceRasterizer(const Vector2f* iPoints, Uint32 iCount);
	
	void rasterize(TScanner& iScanner);
	
protected:
	
	void _swapIfNeeded(Uint32 indices[3], Uint32 iFirstIndex, Uint32 iLastIndex) const;
	void _scanLines(Int32 yStart, Int32 yEnd, float& x1F, float slope1, float& x2F, float slope2, TScanner& iScanner) const;
	
	const Vector2f* const 	_Points;
	const Uint32			_Count;
};


// inlined implementations
template <class TScanner>
inline TFaceRasterizer<TScanner>::TFaceRasterizer(const Vector2f* iPoints, Uint32 iCount)
: _Points(iPoints), _Count(iCount)
{
}

template <class TScanner>
inline void TFaceRasterizer<TScanner>::_swapIfNeeded(Uint32 indices[3], Uint32 iFirstIndex, Uint32 iLastIndex) const
{
	// Descending order
	if (_Points[indices[iFirstIndex]].y > _Points[indices[iLastIndex]].y)
	{
		std::swap(indices[iFirstIndex], indices[iLastIndex]);
	}
}
	
template <class TScanner>	
inline void
TFaceRasterizer<TScanner>::rasterize(TScanner& iScanner)
{
	// Triangulate the face and unmap each triangle
	const Uint32 triangleCount = _Count - 2;
	for (Uint32 i=0; i < triangleCount; ++i)
	{		
		Uint32 indices[3];
		
		indices[0] = 0;
		indices[1] = 1 + i;
		indices[2] = 2 + i;
		
		// Sort the points by scanline up down
		// Unrolled bubble sort
		_swapIfNeeded(indices, 0, 1);
		_swapIfNeeded(indices, 0, 2);
		_swapIfNeeded(indices, 1, 2);
		
		Vector2f dstPoints[3];
		dstPoints[0] = _Points[indices[0]];
		dstPoints[1] = _Points[indices[1]];
		dstPoints[2] = _Points[indices[2]];
		
		TB_ASSERT(dstPoints[0].y <= dstPoints[1].y);
		TB_ASSERT(dstPoints[1].y <= dstPoints[2].y);
		
		// Rasterize top part of triangle
		Int32 yStart = roundToInt(dstPoints[0].y);
		Int32 yEnd = roundToInt(dstPoints[1].y);
		
		const float yDelta1 =  (dstPoints[2].y - dstPoints[0].y);
		float slope1 = (yDelta1 != 0) ? ((dstPoints[2].x - dstPoints[0].x) / yDelta1) : 0;
		
		float yDelta2 =  (dstPoints[1].y - dstPoints[0].y);
		float slope2 = (yDelta2 != 0) ? ((dstPoints[1].x - dstPoints[0].x) / yDelta2) : 0;
		
		float x1F = dstPoints[0].x;
		float x2F = x1F;
		
		iScanner.startUpperSubTriangle();
		_scanLines(yStart, yEnd, x1F, slope1, x2F, slope2, iScanner);
		
		// Rasterize bottom part of triangle
		yStart = yEnd;
		yEnd = roundToInt(dstPoints[2].y);
		
		x1F = dstPoints[0].x;
		x2F = dstPoints[1].x;
		
		yDelta2 = (dstPoints[2].y - dstPoints[1].y);
		slope2 = (yDelta2 != 0) ? ((dstPoints[2].x - dstPoints[1].x) / yDelta2) : 0;
		
		iScanner.startLowerSubTriangle();
		_scanLines(yStart, yEnd, x1F, slope1, x2F, slope2, iScanner);
	}
}

template <class TScanner>	
inline void TFaceRasterizer<TScanner>::_scanLines(Int32 yStart, Int32 yEnd, float& x1F, float slope1, float& x2F, float slope2, TScanner& iScanner) const
{
	for (Int32 y = yStart; y <= yEnd; ++y)
	{
		const Int32 x1 = roundToInt(x1F);
		const Int32 x2 = roundToInt(x2F);
		if (x1 <= x2)
		{
			for (Int32 x = x1; x <= x2; ++x)
			{
				iScanner.scan(x, y);
			}
		}
		else
		{
			for (Int32 x = x2; x <= x1; ++x)
			{
				iScanner.scan(x, y);
			}				
		}
		
		x1F += slope1;
		x2F += slope2;
	}
}
	
	
inline void
ColorScanner::startUpperSubTriangle()
{
	_OutColor = _UpperColor;
}
	
inline void
ColorScanner::startLowerSubTriangle()
{
	_OutColor = _LowerColor;
}

inline void
ColorScanner::scan(Int32 iX, Int32 iY)
{
	ColorRGBA8* color = _OutImage->pixelAtOrNULL(Vector2i(iX, iY));
	if (color != NULL)
	{
		*color = _OutColor;
	}
}
	
} // namespace Toolbox

#endif
