/*
 *  PerspectiveCorrectScanner.cpp
 *  Toolbox
 *
 *  Created by Gougou on 11/08/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "PerspectiveCorrectScanner.h"

namespace Toolbox
{
PerspectiveCorrectScanner::PerspectiveCorrectScanner(const Matrix33f& iProjMatrix, ImageRGBA8& iInputImage, ImageRGBA8& oOutputImage)
: _ProjectiveMatrix(iProjMatrix), _InputImage(iInputImage), _OutputImage(oOutputImage)
{
}

void PerspectiveCorrectScanner::scan(Int32 iX, Int32 iY)
{
	// Note : to optimize and use differential computation on the scan line
	// (iX + 1, iY) - (iX, iY) => dU = value[0][0], dv = value[1][0], dw = value[2][0]
	Vector3f dstP(iX, iY, 1);
	Vector3f srcP;
	_ProjectiveMatrix.transform(dstP, srcP);
	
	srcP.x /= srcP.z;
	srcP.y /= srcP.z;
	
	const ColorRGBA8 srcPixel = _InputImage->pixelOrClearColorAt(Vector2i(srcP.x, srcP.y));
	ColorRGBA8& dstPixel = _OutputImage->pixelAt(Vector2i(iX, iY));
	
	dstPixel = srcPixel;
}
	
	
}
