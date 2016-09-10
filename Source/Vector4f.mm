/*
 *  Vector4f.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Vector4f.h"

namespace Toolbox
{
	
const Vector4f Vector4f::kNull(0.f, 0.f, 0.f, 0.f);
	
Vector4f
Vector4f::interpolate(const Vector4f& iV1, const Vector4f& iV2, Float32 iCoeff)
{
	Vector4f v;
	
	const Float32 c = 1.f - iCoeff;
	
	v.x = (iV1.x * c) + (iV2.x * iCoeff);
	v.y = (iV1.y * c) + (iV2.y * iCoeff);
	v.z = (iV1.z * c) + (iV2.z * iCoeff);
	v.w = (iV1.w * c) + (iV2.w * iCoeff);
	
	return v;
}
	
} // End of toolbox