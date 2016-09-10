/*
 *  Box3D.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Box3D_H_)
#define _Box3D_H_

#include "Node3D.h"
#include "AABoxf.h"
#include "Vertex.h"

namespace Toolbox
{
	class Box3D;
	typedef TSmartPtr<Box3D> P_Box3D;
	
	class Box3D : public Node3D
	{
	public:
		TB_DECLARE_NODE3D(Box3D, Node3D);
		
		// From Node3D
		virtual NodeGesture3D* gestureFromPick(const Ray3D& iGlobalRay, GLView* iGLView);
				
		Box3D(const AABoxf& iBox);
		
		const AABoxf& box() const;
		void setBox(const AABoxf& iBox);
		
		const VertexP* vertices() const;
		
	protected:
		Box3D(const Box3D&);
		
		// From Node3D
		virtual void _selfClone(P_Node3D& oClone) const;
		
		virtual void _localBox(AABoxf& oBox) const;
		virtual bool _selfPick(const Ray3D& iRay, float& oCoeff) const;
		virtual void _render(RenderOptions& ioOptions);
		
	private:
		Box3D() {} // For newInstance
		
		// From SerializableObject
		virtual void _encode(NSCoder* aCoder);
		virtual void _decode(NSCoder* aDecoder);
		
		AABoxf 			_Box;
		VertexP			_Vertices[8];
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline const AABoxf& Box3D::box() const
	{
		return _Box;
	}
	
	inline const VertexP*
	Box3D::vertices() const
	{		
		return _Vertices;
	}
	
}

#endif // _Box3D_H_