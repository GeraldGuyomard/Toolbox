/*
 *  TVector2.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "TVector2.h"

namespace Toolbox
{

template<> const Vector2i Vector2i::kNull(0, 0);
template<> const Vector2i Vector2i::kUnit(1, 1);	
	
template<> const Vector2f Vector2f::kNull(0.f, 0.f);	
template<> const Vector2f Vector2f::kUnit(1.f, 1.f);	
	
} // End of toolbox