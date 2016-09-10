/*
 *  TFaceRasterizer.cpp
 *  Toolbox
 *
 *  Created by Gougou on 11/08/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "TFaceRasterizer.h"

namespace Toolbox
{

ColorScanner::ColorScanner(ImageRGBA8& oImage, const ColorRGBA8& iUpperColor, const ColorRGBA8& iLowerColor)
: _OutImage(oImage), _OutColor(ColorRGBA8::kClearColor), _UpperColor(iUpperColor), _LowerColor(iLowerColor)
{}
	
} // End of namespace Toolbox