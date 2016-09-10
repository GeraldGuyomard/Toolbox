/*
 *  Material.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Material_H_)
#define _Material_H_

#include "RetainedObject.h"
#include "TextureMap.h"
#include "Color.h"

namespace Toolbox
{
class Material;
typedef TSmartPtr<Material> P_Material;

class Material : public RetainedObject<Material>
{
public:
	Material();
	
	void setActive();
	
public:
	P_TextureMap 	texture;

	ColorRGBAF		ambient;
	ColorRGBAF		diffuse;
	ColorRGBAF		emission;
	ColorRGBAF		specular;
	Float32			shininess;
};


// ********************************************************************************
// Inlined Implementations
// ********************************************************************************

	
} // end of namespace Toolbox

#endif // _TextureMap_H_