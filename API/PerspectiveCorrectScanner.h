/*
 *  PerspectiveCorrectScanner.h
 *  Toolbox
 *
 *  Created by Gougou on 11/08/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#if !defined(__PerspectiveCorrectScanner_H__)
#define PerspectiveCorrectScanner_H__

#include "Matrix33f.h"
#include "ImageRGBA8.h"

namespace Toolbox
{

class PerspectiveCorrectScanner
{
public:
	PerspectiveCorrectScanner(const Matrix33f& iProjMatrix, ImageRGBA8& iInputImage, ImageRGBA8& oOutputImage);
	
	void startUpperSubTriangle() {}
	void startLowerSubTriangle() {}
	
	void scan(Int32 iX, Int32 iY);
	
private:
	Matrix33f 		_ProjectiveMatrix;
	P_ImageRGBA8	_InputImage;
	P_ImageRGBA8	_OutputImage;
};

	
}

#endif // PerspectiveCorrectScanner