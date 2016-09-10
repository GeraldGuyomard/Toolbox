/*
 *  Node3D.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Node3D.h"
#include "Ray3D.h"
#include <OpenGLES/ES1/gl.h>
#include <map>

namespace Toolbox
{
#pragma mark RenderOptions

RenderOptions::RenderOptions()
: renderMode(eSolid), wireframeColor(200, 0, 0, 255), wireframeThickness(1)
{}
	
#pragma mark Node3D
	
Node3D::Node3D()
: _Parent(NULL), _LocalMatrix(Matrix44f::kIdentityMatrix)
, _PackedFlags(0)
{}

Node3D::Node3D(const Node3D& iOther)
: _Parent(NULL), _LocalMatrix(iOther._LocalMatrix), _PackedFlags(0)
{
	
}
	
Node3D::~Node3D()
{}
	
void Node3D::setParent(Node3D* iParent)
{
	if (_Parent != iParent)
	{  
		
		if (_Parent != NULL)
		{
			const bool removed = removeElement<P_Node3D>(_Parent->_Children, this);
			TB_ASSERT(removed);			
		}

		
		_Parent = iParent;
		
		if (_Parent != NULL)
		{
			TB_ASSERT(!exists<P_Node3D>(_Parent->_Children, this));
			_Parent->_Children.push_back(this);
		}
	}
}

const Matrix44f& Node3D::globalMatrix() const
{
	if (!_Flags._IsGlobalMatrixComputed)
	{
		_GlobalMatrix = _LocalMatrix;
		if (_Parent != NULL)
		{
			const Matrix44f& parentGlobal = _Parent->globalMatrix();
			_GlobalMatrix *= parentGlobal;
		}
		
		_Flags._IsGlobalMatrixComputed = true;
	}
	
	return _GlobalMatrix;
}

const Matrix44f& Node3D::inverseGlobalMatrix() const
{
	if (!_Flags._IsInverseGlobalMatrixComputed)
	{
		const Matrix44f& g = globalMatrix();
		const bool inverted = g.inverseAffine(_InverseGlobalMatrix);
		TB_ASSERT(inverted);
		
		_Flags._IsInverseGlobalMatrixComputed = true;
	}
	
	return _InverseGlobalMatrix;
}

void Node3D::invalidateTransformCaches()
{
	// Ancestors (BBox only)
	Node3D* ancestor = _Parent;
	while (NULL != ancestor)
	{
		ancestor->_Flags._IsGlobalBoxComputed = false;
		ancestor = ancestor->_Parent;
	}
	
	_invalidateTransformCachesAndChildren();
}

void Node3D::_invalidateTransformCachesAndChildren()
{
	_invalidateTransformCaches();
	
	// and descendents
	
	const ArrayOfNode3D::const_iterator end = _Children.end();
	for (ArrayOfNode3D::const_iterator it = _Children.begin(); it != end; ++it)
	{
		(*it)->_invalidateTransformCachesAndChildren();
	}
}
	
void Node3D::_invalidateTransformCaches()
{
	_PackedFlags = 0;
}

void Node3D::setLocalMatrix(const Matrix44f& iLocal)
{
	_LocalMatrix = iLocal;
	invalidateTransformCaches();
}

void Node3D::setLocalPosition(const Vector3f& iTranslation)
{
	_LocalMatrix.setTranslation(iTranslation);
	invalidateTransformCaches();	
}
	
void Node3D::translate(const Vector3f& iTranslation)
{
	_LocalMatrix.translate(iTranslation);
	invalidateTransformCaches();
}
	
void
Node3D::_render(RenderOptions& ioOptions)
{
}
	
void Node3D::render(RenderOptions& ioOptions)
{
	glPushMatrix();
	const Matrix44f& local = localMatrix();
	glMultMatrixf(local.array);
	
	_render(ioOptions);
	
	const ArrayOfNode3D::const_iterator end = _Children.end();
	for (ArrayOfNode3D::const_iterator it = _Children.begin(); it != end; ++it)
	{
		(*it)->render(ioOptions);
	}
	
	glPopMatrix();
}

void Node3D::_localBox(AABoxf& oBox) const
{
	oBox.setEmpty();
}

void Node3D::localBox(AABoxf& oBox) const
{
	_localBox(oBox);
	
	// Add children's boxes
	const ArrayOfNode3D::const_iterator end = _Children.end();
	for (ArrayOfNode3D::const_iterator it = _Children.begin(); it != end; ++it)
	{
		Node3D* child = *it;
		AABoxf b;
		child->localBox(b);
		b.transformBy(child->localMatrix(), b);
		
		oBox.add(b);
	}
}
	
const AABoxf& Node3D::globalBox() const
{
	if (!_Flags._IsGlobalBoxComputed)
	{
		localBox(_GlobalBox);
		if (!_GlobalBox.isEmpty())
		{
			_GlobalBox.transformBy(globalMatrix(), _GlobalBox);
		}
		
		_Flags._IsGlobalBoxComputed = true;
	}
	
	return _GlobalBox;
}

void
Node3D::globalToLocal(const Ray3D& iGlobalRay, Ray3D& oLocalRay) const
{
	iGlobalRay.transformBy(inverseGlobalMatrix(), oLocalRay);
}
	
Node3D* Node3D::pickNode(const Ray3D& iRay, float& oCoeff)
{
	if (!isLeaf())
	{
		// First easy rejection: try with the global boundind box (including children)
		float minCoeff;
		if (!iRay.intersectsWith(globalBox(), &minCoeff) || (minCoeff < 0.f))
		{
			return NULL;
		}	
	}
	
	// Now work in the local space
	Ray3D localRay;
	globalToLocal(iRay, localRay);
	
	Node3D* candidate = NULL;
	
	// Local Test
	float c = FLT_MAX;
	if (selfPick(localRay, c) && (c >= 0.f) && (c < oCoeff))
	{
		oCoeff = c;
		candidate = this;
	}
	
	// Try children
	const ArrayOfNode3D::const_iterator end = _Children.end();
	for (ArrayOfNode3D::const_iterator it = _Children.begin(); it != end; ++it)
	{
		Node3D* child = *it;
		Node3D* n = child->pickNode(iRay, c);
		if ((NULL != n) && (c < oCoeff))
		{
			TB_ASSERT(c >= 0.f);
			
			candidate = n;
			oCoeff = c;
		}
	}
	
	return candidate;
}

bool Node3D::selfPick(const Ray3D& iLocalRay, float& oCoeff) const
{
	// Test first against the local box
	AABoxf b;
	localBox(b);
	if (!iLocalRay.intersectsWith(b))
	{
		return false;
	}
	
	return _selfPick(iLocalRay, oCoeff);
}
	
bool Node3D::_selfPick(const Ray3D& iRay, float& oCoeff) const
{
	return false;
}

void Node3D::clone(P_Node3D& oClone) const
{
	_selfClone(oClone);
}

void Node3D::_selfClone(P_Node3D& oClone) const
{
	oClone = new Node3D(*this);
}
	
#pragma mark -
	
static NSString* const kLocalMatrixKey = @"LocalMatrix";
static NSString* const kChildrenKey = @"Children";
	
void Node3D::_encode(NSCoder* aCoder)
{
	encodePod(_LocalMatrix, aCoder, kLocalMatrixKey);
	encodeObjectArray(_Children, aCoder, kChildrenKey);
}

void Node3D::_decode(NSCoder* aDecoder)
{	
	decodePod(_LocalMatrix, aDecoder, kLocalMatrixKey);
	decodeObjectArray(_Children, aDecoder, kChildrenKey);
	
	const ArrayOfNode3D::iterator end = _Children.end();
	for (ArrayOfNode3D::iterator it = _Children.begin(); it != end; ++it)
	{
		(*it)->_Parent = this;
	}
	
	invalidateTransformCaches();
}
		
} // End of toolbox