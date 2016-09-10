/*
 *  Material.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Material.h"
#include "GLTools.h"

namespace Toolbox
{
Material::Material()
: ambient(0.1f, 0.1f, 0.1f), diffuse(0.5f, 0.5f, 0.5f), emission(0.f, 0.f, 0.f), specular(0.f, 0.f, 0.f), shininess(0.f)
{
}

void Material::setActive()
{	
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, (const GLfloat*) &ambient);	
	glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, (const GLfloat*) &diffuse);
	glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, (const GLfloat*) &emission);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, (const GLfloat*) &specular);
	glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, shininess);
	
	if (NULL != texture)
	{
		texture->setActive();	
	}
	else
	{
		glDisable(GL_TEXTURE_2D);	
	}
	
}
	
} // End of toolbox