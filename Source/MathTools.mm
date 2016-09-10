/*
 *  MathTools.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "MathTools.h"

namespace Toolbox
{

const Float32 TConstants<Float32>::kDefaultEpsilon = DEFAULT_EPSILON; 
	
Uint32 
nearestButLowestPowerOf2(Uint32 iValue)
{
	iValue += (iValue >> 1);
	iValue |= (iValue >> 1);
	iValue |= (iValue >> 2);
	iValue |= (iValue >> 4);
	iValue |= (iValue >> 8);
	iValue |= (iValue >> 16);
	
	return iValue & ~(iValue >> 1);
}
	
	
} // End of toolbox