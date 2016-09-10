/*
 *  Quad3D.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Quad3D.h"
#include <OpenGLES/ES1/gl.h>
#include "GLTools.h"
#include "AABoxf.h"

namespace Toolbox
{

Quad3D::Quad3D(const Vector2f& iSize, TextureMap& iTexture, const Rectanglei& iZoneInsideTexture, EAxis iNormalAxis)
{
	const Vector2i size = iTexture.size();
	TB_ASSERT(size.x != 0);
	TB_ASSERT(size.y != 0);
	
	const Vector2f r(1.f / Float32(size.x), 1.f / Float32(size.y));
	const Rectanglef uvs(Vector2f(iZoneInsideTexture.origin.x * r.x, iZoneInsideTexture.origin.y * r.y), Vector2f(iZoneInsideTexture.size.x * r.x, iZoneInsideTexture.size.y * r.y));
	
	_init(iSize, iTexture, uvs, iNormalAxis);
}

Quad3D::Quad3D(const Quad3D& iOther)
: SuperClass(iOther), _NormalAxis(iOther._NormalAxis), _Texture(iOther._Texture), _HalfSize(iOther._HalfSize)
{
	memcpy(_Vertices, iOther._Vertices, 4 * sizeof(VertexPUV));
}
	
void Quad3D::_selfClone(P_Node3D& oClone) const
{
	oClone = new Quad3D(*this);
}
	
void
Quad3D::_axisIndices(EAxis& oXIndex, EAxis& oYIndex, EAxis& oZIndex) const
{
	switch(_NormalAxis)
	{
		case eX:
		{
			oXIndex = eY; // -Y ?
			oYIndex = eZ; // -Z ?
			oZIndex = eX; // -X ?
			break;
		}
			
		case eY:
		{
			oXIndex = eX;
			oYIndex = eZ; // -Z ?
			oZIndex = eY; // -Y ?
			break;
		}
			
		case eZ:
		{
			oXIndex = eX;
			oYIndex = eY;
			oZIndex = eZ;
			break;
		}
			
		default:
		{
			TB_ASSERT(false);
		}
	}
}
	
void
Quad3D::_init(const Vector2f& iSize, TextureMap& iTexture, const Rectanglef& iUVs, EAxis iNormalAxis)
{
	_NormalAxis 	= iNormalAxis;
	_HalfSize		= iSize * 0.5f;
	_Texture 	 	= iTexture;
	
	if (NULL != _Texture)
	{
		EAxis xIndex, yIndex, zIndex;
		_axisIndices(xIndex, yIndex, zIndex);
		
		const Float32 uLeft = iUVs.origin.x;
		const Float32 uRight = iUVs.origin.x + iUVs.size.x;

		const Float32 vTop = 1.f - (iUVs.origin.y + iUVs.size.y);
		const Float32 vBottom = 1.f - iUVs.origin.y;
		 
		VertexPUV* vertex = _Vertices;
		
		vertex->position[eX] = -_HalfSize.x;
		vertex->position[eY] = _HalfSize.y;
		vertex->position[eZ] = 0.f;
		vertex->uv.setCoordinates(uLeft, vBottom);
		++vertex;

		vertex->position[eX] = _HalfSize.x;
		vertex->position[eY] = _HalfSize.y;
		vertex->position[eZ] = 0.f;
		vertex->uv.setCoordinates(uRight, vBottom);
		++vertex;

		vertex->position[eX] = _HalfSize.x;
		vertex->position[eY] = -_HalfSize.y;
		vertex->position[eZ] = 0.f;
		vertex->uv.setCoordinates(uRight, vTop);
		++vertex;

		vertex->position[eX] = -_HalfSize.x;
		vertex->position[eY] = -_HalfSize.y;
		vertex->position[eZ] = 0.f;
		vertex->uv.setCoordinates(uLeft, vTop);
	}	
}

void
Quad3D::_localBox(AABoxf& oLocalBox) const
{
	EAxis x, y, z;
	_axisIndices(x, y, z);
	
	oLocalBox.minCorner[x] = -_HalfSize.x;
	oLocalBox.minCorner[y] = -_HalfSize.y;
	oLocalBox.minCorner[z] = 0.f;

	oLocalBox.maxCorner[x] = _HalfSize.x;
	oLocalBox.maxCorner[y] = _HalfSize.y;
	oLocalBox.maxCorner[z] = 0.f;
}
	
void
Quad3D::_render(RenderOptions& ioOptions)
{
	if (_Texture != NULL)
	{
		glDisable(GL_LIGHTING);
		
		/*if (_EnableBackfaceCulling)
		{
			glEnable(GL_CULL_FACE);
		}
		else*/
		{
			glDisable(GL_CULL_FACE);
		}
		
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glDisableClientState(GL_NORMAL_ARRAY);
		
		_Texture->setActive();
		
		glVertexPointer(3, GL_FLOAT, sizeof(VertexPUV), &_Vertices[0].position);
		glTexCoordPointer(2, GL_FLOAT, sizeof(VertexPUV), &_Vertices[0].uv);
		
		static GLbyte indices[4] = {0, 1, 3, 2 };
		glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_BYTE, indices);
	}
}

void Quad3D::_encode(NSCoder* aCoder)
{
	SuperClass::_encode(aCoder);
	
	TB_ASSERT(false); // TODO
}
	
void Quad3D::_decode(NSCoder* aDecoder)
{
	SuperClass::_decode(aDecoder);
	
	TB_ASSERT(false); // TODO	
}
	
} // End of toolbox