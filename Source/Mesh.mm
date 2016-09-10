/*
 *  Mesh.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Mesh.h"


namespace Toolbox
{

Mesh::Mesh()
: features(0)
{}

void Mesh::render()
{
	_selfRender();
	
	const std::vector<P_Mesh>::const_iterator end = subMeshes.end();
	for (std::vector<P_Mesh>::const_iterator it = subMeshes.begin(); it != end; ++it)
	{
		(*it)->render();
	}
}

void Mesh::_selfRender()
{
	if (NULL == material)
	{
		return;
	}
	
	const Uint32 indicesCount = indices.size();
	if (indicesCount == 0)
	{
		return;
	}
	
	material->setActive();
	
	glVertexPointer(3, GL_FLOAT, sizeof(VertexPUVNormal), (const Float32*) &vertices[0].position);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	if (features & fNormals)
	{
		glEnableClientState(GL_NORMAL_ARRAY);		
		glNormalPointer(GL_FLOAT, sizeof(VertexPUVNormal), (const GLvoid*) &vertices[0].normal);		
	}
	else
	{
		glDisableClientState(GL_NORMAL_ARRAY);
	}
	
	if (features & fUVs)
	{
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glTexCoordPointer(2, GL_FLOAT, sizeof(VertexPUVNormal), (const GLvoid*) &vertices[0].uv);
	}
	else
	{
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);	
	}
	
	glDrawElements(GL_TRIANGLES, indicesCount, GL_UNSIGNED_SHORT, &indices.front());
}
	
} // End of toolbox