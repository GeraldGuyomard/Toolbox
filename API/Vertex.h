/*
 *  Vertex.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Vertex_H_)
#define _Vertex_H_

#include "Vector3f.h"
#include "TVector2.h"
#include "Matrix44f.h"

namespace Toolbox
{
	
	struct VertexP
	{
		Vector3f position;
		
		void transformBy(const Matrix44f& iMatrix, VertexP& oVertex) const;
	};
	
	struct VertexPUV
	{
		Vector3f 	position;
		Vector2f	uv;
	};
	
	struct VertexPUVNormal
	{
		Vector3f 	position;
		Vector2f	uv;
		Vector3f	normal;
	};
	
	inline void VertexP::transformBy(const Matrix44f& iMatrix, VertexP& oVertex) const
	{
		iMatrix.transformPoint((const Vector3f&) *this, (Vector3f&) oVertex);
	}
}

#endif // _Vertex_H_