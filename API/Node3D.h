/*
 *  Node3D.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Node3D_H_)
#define _Node3D_H_

#include "SerializableObject.h"
#include "vectorEx.h"
#include "Matrix44f.h"
#include "AABoxf.h"
#include "Color.h"
#include <string>


@class GLView, NodeGesture3D;

#define TB_DECLARE_ABSTRACT_NODE3D(ClassName, SuperClassName) TB_DECLARE_ABSTRACT_SERIALIZABLE_OBJECT(ClassName, SuperClassName)
#define TB_DECLARE_NODE3D(ClassName, SuperClassName) TB_DECLARE_SERIALIZABLE_OBJECT(ClassName, SuperClassName)

namespace Toolbox
{
	class RenderOptions
	{
	public:
		RenderOptions();
		
		enum ERenderMode
		{
			eWireFrame,
			eSolid
		};
		
		ERenderMode renderMode;
		ColorRGBA8	wireframeColor;
		Float32		wireframeThickness;
	};
	
	class Ray3D;
	
	class Node3D;
	typedef TSmartPtr<Node3D> P_Node3D;
	
	typedef std::vector<P_Node3D> ArrayOfNode3D;
	
	class Node3D : public SerializableObject
	{
	public:
		
		TB_DECLARE_NODE3D(Node3D, SerializableObject);
		
		Node3D();
		virtual ~Node3D();
		
		void clone(P_Node3D& oClone) const;
		
		void setParent(Node3D* iParent);
		const ArrayOfNode3D& children() const;
		
		const Matrix44f& localMatrix() const;
		void setLocalMatrix(const Matrix44f& iLocal);
		
		const Vector3f& localPosition() const;
		void setLocalPosition(const Vector3f& iTranslation);
		
		const Matrix44f& globalMatrix() const;
		const Matrix44f& inverseGlobalMatrix() const;
		
		void localBox(AABoxf& oBox) const;
		const AABoxf& globalBox() const;
		
		void translate(const Vector3f& iTranslation);
		void invalidateTransformCaches();
		
		void render(RenderOptions& ioOptions);
		
		bool isLeaf() const;
		
		void globalToLocal(const Ray3D& iGlobalRay, Ray3D& oLocalRay) const;
		
		Node3D* pickNode(const Ray3D& iGlobalRay, float& oCoeff);
		Node3D* pickNode(const Ray3D& iGlobalRay);
		
		bool selfPick(const Ray3D& iLocalRay, float& oCoeff) const;
		
	protected:
		Node3D(const Node3D&);
		
		void _invalidateTransformCachesAndChildren();
		
		// From SerializableObject
		virtual void _encode(NSCoder* aCoder);
		virtual void _decode(NSCoder* aDecoder);
						   
		virtual void _localBox(AABoxf& oBox) const; // Not including children
		virtual void _invalidateTransformCaches();
		virtual void _render(RenderOptions& ioOptions);
		
		virtual bool _selfPick(const Ray3D& iLocalRay, float& oCoeff) const;
		virtual void _selfClone(P_Node3D& oClone) const;
		
	private:
		Node3D* 					_Parent;
		ArrayOfNode3D 				_Children;
		
		Matrix44f					_LocalMatrix;
		
		mutable Matrix44f			_GlobalMatrix;
		mutable Matrix44f			_InverseGlobalMatrix;
		mutable AABoxf				_GlobalBox;
		
		struct Flags
		{
			Uint32	_IsGlobalMatrixComputed: 1;
			Uint32	_IsInverseGlobalMatrixComputed: 1;
			Uint32	_IsGlobalBoxComputed:1;
		};

		union
		{
			mutable Flags 	_Flags;
			mutable Uint32	_PackedFlags;
		};
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline const Matrix44f& Node3D::localMatrix() const
	{
		return _LocalMatrix;
	}
	
	inline bool Node3D::isLeaf() const
	{
		return _Children.empty();
	}
	
	inline const ArrayOfNode3D& Node3D::children() const
	{
		return _Children;
	}
	
	inline const Vector3f& Node3D::localPosition() const
	{
		return localMatrix().translation();	
	}
	
	inline Node3D* Node3D::pickNode(const Ray3D& iRay)
	{
		float c = FLT_MAX;
		return pickNode(iRay, c);
	}
}

#endif // _Node3D_H_