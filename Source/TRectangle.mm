/*
 *  TVector2.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "TRectangle.h"

namespace Toolbox
{

template<> const Rectanglei Rectanglei::kNull(Vector2i::kNull, Vector2i::kNull);
template<> const Rectanglei Rectanglei::kUnit(Vector2i::kNull, Vector2i::kUnit);
	
template<> const Rectanglef Rectanglef::kNull(Vector2f::kNull, Vector2f::kNull);	
template<> const Rectanglef Rectanglef::kUnit(Vector2f::kNull, Vector2f::kUnit);
	
} // End of toolbox