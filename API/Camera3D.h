/*
 *  Camera3D.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Camera3D_H_)
#define _Camera3D_H_

#include "Node3D.h"
#include "TVector2.h"

namespace Toolbox
{
	class Ray3D;
	
	class Camera3D : public Node3D
	{
	public:
		TB_DECLARE_ABSTRACT_NODE3D(Camera3D, Node3D);
		
		const Vector2f& viewportSize() const;
		void setViewportSize(const Vector2f& iSize);
		
		const Matrix44f& projectionMatrix() const;
		
		Float32 zNear() const;
		Float32 zFar() const;
		
		const Vector2f& panOffset() const;
		void setPanOffset(const Vector2f& iOffset);
		
		Float32 zoomFactor() const;
		void setZoomFactor(Float32 iFactor);
		
		void resetZoomAndPan();
		
		virtual void pan3D(const Vector2f& iScreenPan, const Vector3f* iKeepThisGlobalPointAtSamePos = NULL) = 0;
		
		void ray(const Vector2f& iScreenPoint, Ray3D& oRay) const;
		void projectPoints(const Vector3f* iPoints, Vector3f* oPoints, Uint32 iCount, bool iConvertInUIKitCoordinates = true) const;
		void projectPoints(const Vector3f* iPoints, Vector2f* oPoints, Uint32 iCount, bool iConvertInUIKitCoordinates = true) const;
		void projectPoint(const Vector3f& iPoint, Vector3f& oPoint, bool iConvertInUIKitCoordinates = true) const;
		
		void setActive(const Vector2f& iRenderSize);
		
		void zoom(Float32 iZoom);
		void pan(const Vector2f& iPanDirection);
		
	protected:
		Camera3D(Float32 iNear, Float32 iFar, const Vector2f& iViewportSize);
		
		// From SerializableObject
		virtual void _encode(NSCoder* aCoder);
		virtual void _decode(NSCoder* aDecoder);
		
		// From Node3D
		Camera3D(const Camera3D& iOther);
		
		virtual void _invalidateTransformCaches();
		
		virtual void _updateProjectionMatrix() const = 0;
		virtual void _localRay(const Vector2f& iScreenPoint, Ray3D& oRay) const = 0;
		
		Vector2f			_ViewportSize;
		Float32				_ZNear;
		Float32				_ZFar;
		
		Vector2f			_PanOffset;
		Float32				_ZoomFactor;
		
		mutable Matrix44f 	_ProjectionMatrix;
		mutable Uint32		_IsProjectionMatrixComputed : 1;
	};
	typedef TSmartPtr<Camera3D> P_Camera3D;

	class OrthoCamera3D : public Camera3D
	{
	public:
		TB_DECLARE_NODE3D(OrthoCamera3D, Camera3D);
		
		OrthoCamera3D(Float32 iNear=-100.f, Float32 iFar=100.f, const Vector2f& iViewportSize = Vector2f(1.f, 1.f));
		
		virtual void pan3D(const Vector2f& iScreenPan, const Vector3f* iKeepThisGlobalPointAtSamePos = NULL);
		
	protected:		
		// From Node3D
		virtual void _selfClone(P_Node3D& oClone) const;
		
		// From Camera3D
		virtual void _updateProjectionMatrix() const;
		virtual void _localRay(const Vector2f& iScreenPoint, Ray3D& oRay) const;
	};
	typedef TSmartPtr<OrthoCamera3D> P_OrthoCamera3D;
	
	class PerspectiveCamera3D : public Camera3D
	{
	public:
		TB_DECLARE_NODE3D(PerspectiveCamera3D, Camera3D);
		
		PerspectiveCamera3D(Float32 iFov=45.f, Float32 iNear=10.f, Float32 iFar=1000.f, const Vector2f& iViewportSize = Vector2f(1.f, 1.f));
		
		virtual void pan3D(const Vector2f& iScreenPan, const Vector3f* iKeepThisGlobalPointAtSamePos = NULL);
		
		// native FOV (used to horizontal FOV)
		Float32 fov() const;
		void setFov(Float32 iNewFov);
		
		// Orthogonal FOV
		Float32 orthoFOV() const;
		
		Float32 aspectRatio() const;
		void setOverriddenAspectRatio(Float32 iAspectRatio);
		void resetAspectRatio();
		
		void setSwapViewportDimensions(bool iSwap);
		
	protected:
		PerspectiveCamera3D(const PerspectiveCamera3D&);
		
		// From Node3D
		virtual void _selfClone(P_Node3D& oClone) const;
		
		// From SerializableObject
		virtual void _encode(NSCoder* aCoder);
		virtual void _decode(NSCoder* aDecoder);
		
		// From Camera3D
		virtual void _updateProjectionMatrix() const;
		virtual void _localRay(const Vector2f& iScreenPoint, Ray3D& oRay) const;
		
		void _halfsize(Vector2f& oHalfsize) const;
		
	private:
		Float32		_Fov;
		Float32		_OverriddenAspectRatio; // Default is 0, no override
		bool		_SwapViewportDimensions;
	};
	typedef TSmartPtr<PerspectiveCamera3D> P_PerspectiveCamera3D;
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline Float32 Camera3D::zNear() const
	{
		return _ZNear;
	}
	
	inline Float32 Camera3D::zFar() const
	{
		return _ZFar;
	}
	
	inline const Vector2f& Camera3D::panOffset() const
	{
		return _PanOffset;
	}
	
	inline Float32 Camera3D::zoomFactor() const
	{
		return _ZoomFactor;
	}
	
	inline const Vector2f& Camera3D::viewportSize() const
	{
		return _ViewportSize;
	}
	
	inline void Camera3D::projectPoint(const Vector3f& iPoint, Vector3f& oPoint, bool iConvertInUIKitCoordinates) const
	{
		projectPoints(&iPoint, &oPoint, 1, iConvertInUIKitCoordinates);
	}
	
	inline Float32 PerspectiveCamera3D::fov() const
	{
		return _Fov;
	}
	
	inline void PerspectiveCamera3D::resetAspectRatio()
	{
		setOverriddenAspectRatio(0.f);
	}
}

#endif // _Camera3D_H_