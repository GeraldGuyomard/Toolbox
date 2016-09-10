/*
 *  Quad3D.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Quad3D_H_)
#define _Quad3D_H_

#include "Node3D.h"
#include "TextureMap.h"
#include "MathTools.h"
#include "Vertex.h"
#include "TRectangle.h"

namespace Toolbox
{
	class Quad3D;
	typedef TSmartPtr<Quad3D> P_Quad3D;
	
	class Quad3D : public Node3D
	{
	public:
		TB_DECLARE_NODE3D(Quad3D, Node3D);
		
		Quad3D(const Vector2f& iSize, TextureMap& iTexture, const Rectanglef& iUVs = Rectanglef::kUnit, EAxis iNormalAxis = eZ);
		Quad3D(const Vector2f& iSize, TextureMap& iTexture, const Rectanglei& iZoneInsideTexture, EAxis iNormalAxis = eZ);
		
	protected:
		Quad3D(const Quad3D&);
		
		// From SerializableObject
		virtual void _encode(NSCoder* aCoder);
		virtual void _decode(NSCoder* aDecoder);
		
		// From Node3D
		virtual void _selfClone(P_Node3D& oClone) const;
		
		virtual void _localBox(AABoxf& oBox) const;
		virtual void _render(RenderOptions& ioOptions);
		
		void _axisIndices(EAxis& oXIndex, EAxis& oYIndex, EAxis& oZIndex) const;
		
		void _init(const Vector2f& iSize, TextureMap& iTexture, const Rectanglef& iUVs, EAxis iNormalAxis);
		
		EAxis			_NormalAxis;
		Vector2f		_HalfSize;
		VertexPUV 		_Vertices[4];
		P_TextureMap 	_Texture;
		
	private:
		Quad3D() // for newInstance
		{}
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline Quad3D::Quad3D(const Vector2f& iSize, TextureMap& iTexture, const Rectanglef& iUVs, EAxis iNormalAxis)
	{
		_init(iSize, iTexture, iUVs, iNormalAxis);
	}
}

#endif // _Quad3D_H_