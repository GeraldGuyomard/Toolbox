/*
 *  Camera3D.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Camera3D.h"
#include "MathTools.h"
#include "Ray3D.h"

#include <OpenGLES/ES1/gl.h>

namespace Toolbox
{

#pragma mark Camera3D
	
Camera3D::Camera3D(Float32 iNear, Float32 iFar, const Vector2f& iViewportSize)
: _ZNear(iNear), _ZFar(iFar),
_PanOffset(0.f, 0.f), _ZoomFactor(1.f),
_ViewportSize(iViewportSize),
_IsProjectionMatrixComputed(false)
{
}

Camera3D::Camera3D(const Camera3D& iOther)
: SuperClass(iOther),
_ZNear(iOther._ZNear), _ZFar(iOther._ZFar), _PanOffset(iOther._PanOffset),
_ZoomFactor(iOther._ZoomFactor), _ViewportSize(iOther._ViewportSize),
_IsProjectionMatrixComputed(false)	
{	
}
	
void Camera3D::setViewportSize(const Vector2f& iSize)
{
	if (iSize != _ViewportSize)
	{
		_ViewportSize = iSize;
		_IsProjectionMatrixComputed = false;
	}
}

void Camera3D::setPanOffset(const Vector2f& iPanOffset)
{
	if (iPanOffset != _PanOffset)
	{
		_PanOffset = iPanOffset;
		_IsProjectionMatrixComputed = false;
	}
}

void Camera3D::setZoomFactor(Float32 iFactor)
{
	if (iFactor != _ZoomFactor)
	{
		_ZoomFactor = iFactor;
		_IsProjectionMatrixComputed = false;
	}
}

void Camera3D::resetZoomAndPan()
{
	setZoomFactor(1.f);
	setPanOffset(Vector2f::kNull);
}
	
const Matrix44f& Camera3D::projectionMatrix() const
{
	if (!_IsProjectionMatrixComputed)
	{
		_updateProjectionMatrix();
		_IsProjectionMatrixComputed = true;
	}
	
	return _ProjectionMatrix;	
}

void Camera3D::setActive(const Vector2f& iRenderSize)
{
	setViewportSize(iRenderSize);
	
	glViewport(0, 0, iRenderSize.x, iRenderSize.y);
	
	glMatrixMode(GL_PROJECTION);
	const Matrix44f& projMatrix = projectionMatrix();
	glLoadMatrixf(projMatrix.array);
	
	glMatrixMode(GL_MODELVIEW);
	const Matrix44f& invGlobalMatrix = inverseGlobalMatrix();
	glLoadMatrixf(invGlobalMatrix.array);
}

void Camera3D::_invalidateTransformCaches()
{
	Node3D::_invalidateTransformCaches();
	
	_IsProjectionMatrixComputed = false;
}

void Camera3D::ray(const Vector2f& iScreenPoint, Ray3D& oRay) const
{
	_localRay(iScreenPoint, oRay);
	oRay.transformBy(globalMatrix(), oRay);
}

void Camera3D::projectPoints(const Vector3f* iPoints, Vector3f* oPoints, Uint32 iCount, bool iConvertInUIKitCoordinates) const
{		
	Vector2f halfsize = _ViewportSize * 0.5f;
	
	const Matrix44f& viewMatrix = inverseGlobalMatrix();
	const Matrix44f& projMatrix = projectionMatrix();
	
	Matrix44f m = viewMatrix * projMatrix;
	
	for (Uint32 i=0; i < iCount; ++i)
	{
		Vector3f p;
		m.transformPoint(*(iPoints++), p);
		
		if (iConvertInUIKitCoordinates)
		{
			p.x = (1.f + p.x) * halfsize.x;
			p.y = (1.f - p.y) * halfsize.y;	
		}
		else
		{
			p.x *= halfsize.x;
			p.y *= halfsize.y;
		}
				
		*(oPoints++) = p;
	}
}

void Camera3D::projectPoints(const Vector3f* iPoints, Vector2f* oPoints, Uint32 iCount, bool iConvertInUIKitCoordinates) const
{		
	Vector2f halfsize = _ViewportSize * 0.5f;
	
	const Matrix44f& viewMatrix = inverseGlobalMatrix();
	const Matrix44f& projMatrix = projectionMatrix();
	
	Matrix44f m = viewMatrix * projMatrix;
	
	for (Uint32 i=0; i < iCount; ++i)
	{
		Vector3f p;
		m.transformPoint(*(iPoints++), p);
		
		if (iConvertInUIKitCoordinates)
		{
			p.x = (1.f + p.x) * halfsize.x;
			p.y = (1.f - p.y) * halfsize.y;	
		}
		else
		{
			p.x *= halfsize.x;
			p.y *= halfsize.y;
		}
		
		(oPoints++)->setCoordinates(p.x, p.y);
	}
}

void Camera3D::zoom(Float32 iZoom)
{
	Vector3f dir = localMatrix().direction();	
	Vector3f pos = localPosition();
	pos += dir * iZoom;
	
	setLocalPosition(pos);
}

void Camera3D::pan(const Vector2f& iPanDirection)
{
	const Matrix44f& m = localMatrix();
	Vector3f up = m.up();
	up.normalize();
	
	Vector3f right = m.right();
	right.normalize();
	
	Vector3f pos = m.translation();
	pos += (right * iPanDirection.x);
	pos += (up * iPanDirection.y);
	
	setLocalPosition(pos);
}
	
static NSString* const kNearKey = @"Near";
static NSString* const kFarKey = @"Far";
	
void Camera3D::_encode(NSCoder* aCoder)
{
	SuperClass::_encode(aCoder);
	
	[aCoder encodeFloat:_ZNear forKey:kNearKey];
	[aCoder encodeFloat:_ZFar forKey:kFarKey];
}
	
void Camera3D::_decode(NSCoder* aDecoder)
{
	SuperClass::_decode(aDecoder);
	
	_ZNear = [aDecoder decodeFloatForKey:kNearKey];
	_ZFar = [aDecoder decodeFloatForKey:kFarKey];
	
	_IsProjectionMatrixComputed = false;
}
	
#pragma mark OrthoCamera3D
OrthoCamera3D::OrthoCamera3D(Float32 iNear, Float32 iFar, const Vector2f& iViewportSize)
: Camera3D(iNear, iFar, iViewportSize)
{}

// From Node3D
void OrthoCamera3D::_selfClone(P_Node3D& oClone) const
{
	oClone = new OrthoCamera3D(*this);
}
	
void OrthoCamera3D::pan3D(const Vector2f& iScreenPan, const Vector3f* iKeepThisGlobalPointAtSamePos)
{
	Vector3f translation(-iScreenPan.x, -iScreenPan.y, 0);
	
	translation.x /= _ViewportSize.x;
	translation.y /= _ViewportSize.y;
	
	translate(translation);
}
	
void
OrthoCamera3D::_updateProjectionMatrix() const
{
	_ProjectionMatrix.value[0][0] = (2.f * _ZoomFactor) / _ViewportSize.x; // 2 / (right - left)
	_ProjectionMatrix.value[0][1] = 0.f;
	_ProjectionMatrix.value[0][2] = 0.f;
	_ProjectionMatrix.value[0][3] = 0.f;
	
	_ProjectionMatrix.value[1][0] = 0.f;
	_ProjectionMatrix.value[1][1] = (2.f * _ZoomFactor) / _ViewportSize.y; // 2 / (top - bottom)
	_ProjectionMatrix.value[1][2] = 0.f;
	_ProjectionMatrix.value[1][3] = 0.f;
	
	_ProjectionMatrix.value[2][0] = 0.f;
	_ProjectionMatrix.value[2][1] = 0.f;
	_ProjectionMatrix.value[2][2] = -2.f / (_ZFar - _ZNear);
	_ProjectionMatrix.value[2][3] = 0.f;
	
	_ProjectionMatrix.value[3][0] = (2.f * _PanOffset.x * _ZoomFactor) / _ViewportSize.x;
	_ProjectionMatrix.value[3][1] = (2.f * _PanOffset.y * _ZoomFactor) / _ViewportSize.y;
	_ProjectionMatrix.value[3][2] = (_ZFar + _ZNear) / (_ZFar - _ZNear); 
	_ProjectionMatrix.value[3][3] = 1.f;
}

void
OrthoCamera3D::_localRay(const Vector2f& iScreenPoint, Ray3D& oRay) const
{
	Vector3f origin((iScreenPoint.x - (_ViewportSize.x * 0.5f) - (_ZoomFactor * _PanOffset.x)) / (_ZoomFactor * _ViewportSize.x), ((_ViewportSize.y * 0.5f) - iScreenPoint.y - (_ZoomFactor * _PanOffset.y)) / (_ZoomFactor * _ViewportSize.y), -_ZNear);
	oRay.createWithDirection(origin, -Vector3f::kZ);
}
	
#pragma mark PerspectiveCamera3D
PerspectiveCamera3D::PerspectiveCamera3D(Float32 iFov, Float32 iNear, Float32 iFar, const Vector2f& iViewportSize)
: Camera3D(iNear, iFar, iViewportSize), _Fov(iFov), _OverriddenAspectRatio(0.f), _SwapViewportDimensions(false)
{
}

PerspectiveCamera3D::PerspectiveCamera3D(const PerspectiveCamera3D& iOther)
: SuperClass(iOther), _Fov(iOther._Fov), _OverriddenAspectRatio(iOther._OverriddenAspectRatio), _SwapViewportDimensions(iOther._SwapViewportDimensions)
{}
	
void PerspectiveCamera3D::_selfClone(P_Node3D& oClone) const
{
	oClone = new PerspectiveCamera3D(*this);
}

void PerspectiveCamera3D::setFov(Float32 iFov)
{
	if (_Fov != iFov)
	{
		_Fov = iFov;
		_IsProjectionMatrixComputed = false;
	}
}
	
Float32 PerspectiveCamera3D::orthoFOV() const
{
	// Compute other FOV
	const float r = aspectRatio();
	const float vFOV = 2.f * atanf(tanf(degreesInRadians(_Fov) / 2.f) / r);
	return radiansInDegrees(vFOV);
}
	
void PerspectiveCamera3D::pan3D(const Vector2f& iScreenPan, const Vector3f* iKeepThisGlobalPointAtSamePos)
{
	const Matrix44f& g = globalMatrix();
	
	Vector3f up = g.up();
	up.normalize();
	
	Vector3f right = g.right();
	right.normalize();
	
	Vector3f x = right * iScreenPan.x;
	Vector3f y = up * -iScreenPan.y;
	
	if (NULL != iKeepThisGlobalPointAtSamePos)
	{
		Vector3f p;
		inverseGlobalMatrix().transformPoint(*iKeepThisGlobalPointAtSamePos, p);
		x *= p.z;
		y *= p.z;
	}
	
	Vector2f hs;
	_halfsize(hs);
	
	x *= (2.f * hs.x) / (_ZNear * _ViewportSize.x * _ZoomFactor);
	y *= (2.f * hs.y) / (_ZNear * _ViewportSize.y * _ZoomFactor);
	
	Vector3f t = x + y;
	
	translate(t);
}

	
Float32 PerspectiveCamera3D::aspectRatio() const
{
	return (_OverriddenAspectRatio != 0.f) ? _OverriddenAspectRatio : (_ViewportSize.x / _ViewportSize.y);
}
	
void PerspectiveCamera3D::setOverriddenAspectRatio(Float32 iAspectRatio)
{
	if (_OverriddenAspectRatio != iAspectRatio)
	{
		_OverriddenAspectRatio = iAspectRatio;
		_IsProjectionMatrixComputed = false;
	}
}

void PerspectiveCamera3D::setSwapViewportDimensions(bool iSwap)
{
	_SwapViewportDimensions = iSwap;
}
	
void PerspectiveCamera3D::_halfsize(Vector2f& oHalfsize) const
{
	oHalfsize.x = _ZNear * tanf(degreesInRadians(_Fov) / 2.0f);
	const Float32 r = aspectRatio();
	oHalfsize.y = oHalfsize.x / r;
	
	if (_SwapViewportDimensions)
	{
		std::swap(oHalfsize.x, oHalfsize.y);
	}
}

static NSString* const kFOVKey = @"FOV";
	
void PerspectiveCamera3D::_encode(NSCoder* aCoder)
{
	SuperClass::_encode(aCoder);
	
	[aCoder encodeFloat:_Fov forKey:kFOVKey];
}
	
void PerspectiveCamera3D::_decode(NSCoder* aDecoder)
{
	SuperClass::_decode(aDecoder);
	
	_Fov = [aDecoder decodeFloatForKey:kFOVKey];
}
	
void
PerspectiveCamera3D::_updateProjectionMatrix() const
{
	Vector2f halfsize;
	_halfsize(halfsize);
	
	// See OpenGL Reference Manual, glFrustrum's Page
	
	// Row 0
	_ProjectionMatrix.value[0][0] = (_ZNear * _ZoomFactor) / halfsize.x;
	_ProjectionMatrix.value[0][1] = 0.f;
	_ProjectionMatrix.value[0][2] = 0.f;
	_ProjectionMatrix.value[0][3] = 0.f;
	
	// Row 1
	_ProjectionMatrix.value[1][0] = 0.f;
	_ProjectionMatrix.value[1][1] = (_ZNear * _ZoomFactor) / halfsize.y;
	_ProjectionMatrix.value[1][2] = 0.f;
	_ProjectionMatrix.value[1][3] = 0.f;
	
	// Row 2
	_ProjectionMatrix.value[2][0] = (-2.f * _PanOffset.x * _ZoomFactor) / _ViewportSize.x; //0.f;
	_ProjectionMatrix.value[2][1] = (-2.f * _PanOffset.y * _ZoomFactor) / _ViewportSize.y; //0.f;
	const Float32 zDelta = (_ZFar - _ZNear);
	_ProjectionMatrix.value[2][2] = -(_ZFar + _ZNear) / zDelta;
	_ProjectionMatrix.value[2][3] = -1.f;
	
	// Row 3
	_ProjectionMatrix.value[3][0] = 0;
	_ProjectionMatrix.value[3][1] = 0;
	_ProjectionMatrix.value[3][2] = -2.f * (_ZFar * _ZNear) / zDelta;
	_ProjectionMatrix.value[3][3] = 0.f;	
}
	
void
PerspectiveCamera3D::_localRay(const Vector2f& iScreenPoint, Ray3D& oRay) const
{		
	Vector3f pos((iScreenPoint.x - (_ViewportSize.x * 0.5f) - (_ZoomFactor * _PanOffset.x)) / (_ZoomFactor * _ViewportSize.x), ((_ViewportSize.y * 0.5f) - iScreenPoint.y - (_ZoomFactor * _PanOffset.y)) / (_ZoomFactor * _ViewportSize.y), -_ZNear);

	Vector2f halfsize;
	_halfsize(halfsize);

	pos.x *= 2.f * halfsize.x;
	pos.y *= 2.f * halfsize.y;
	
	oRay.createWithDirection(Vector3f::kNull, pos);
}

} // End of toolbox