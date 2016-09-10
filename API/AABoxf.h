/*
 *  AABoxf.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_AABoxf_H_)
#define _AABoxf_H_

#include "Vector3f.h"
#include "Plane3D.h"

namespace Toolbox
{
	class Matrix44f;
	
	class AABoxf
	{
	public:
		Vector3f minCorner;
		Vector3f maxCorner;
		
	public:
		AABoxf();
		AABoxf(const Vector3f& iMinCorner, const Vector3f& iMaxCorner);
		
		bool isEmpty() const;
		void setEmpty();
		
		Vector3f center() const;
		Vector3f size() const;
		Vector3f halfSize() const;
		
		Float32 maxDimension() const;
		
		void points(Vector3f* oPoints, size_t iStride = sizeof(Vector3f)) const;
		template <typename TVertex> void vertices(TVertex* oVertices) const;
		
		Vector3f point(Uint32 iPointIndex) const;
		
		void add(const Vector3f& iPoint);
		void add(const AABoxf& iOther);
		
		void setSize(const Vector3f& iSize);
		
		bool operator==(const AABoxf& iOther) const;
		bool operator!=(const AABoxf& iOther) const;
		
		void transformBy(const Matrix44f& iMatrix, AABoxf& oBox) const;
		
		enum EPlaneID
		{
			eBackPlane = 0,
			eFrontPlane,
			eLeftPlane,
			eRightPlane,
			eBottomPlane,
			eTopPlane,
			
			ePlaneCount
		};
		void planes(Plane3D oPlanes[ePlaneCount]) const;
		void pointsOfPlane(EPlaneID iPlaneID, Vector3f* oPoints, size_t iStride = sizeof(Vector3f)) const;
		
		// indices between 0 and 7
		static void pointIndicesOfPlane(EPlaneID iPlaneID, Uint32 oIndices[4]);
		
		bool contains(const Vector3f& iPoint) const;
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline AABoxf::AABoxf()
	{}
	
	inline AABoxf::AABoxf(const Vector3f& iMinCorner, const Vector3f& iMaxCorner)
	: minCorner(iMinCorner), maxCorner(iMaxCorner)
	{}

	inline bool AABoxf::isEmpty() const
	{
		return (minCorner.x >= maxCorner.x) || (minCorner.y >= maxCorner.y) || (minCorner.z >= maxCorner.z);
	}
	
	inline Float32 AABoxf::maxDimension() const
	{
		return size().maxDimension();
	}
	
	inline Vector3f AABoxf::center() const
	{
		Vector3f c = maxCorner + minCorner;
		c *= 0.5f;
		
		return c;
	}
	
	inline Vector3f AABoxf::size() const
	{
		return maxCorner - minCorner;
	}
	
	inline Vector3f AABoxf::halfSize() const
	{
		Vector3f hs = maxCorner - minCorner;
		hs *= 0.5f;
		return hs;
	}
	
	inline void AABoxf::setSize(const Vector3f& iSize)
	{
		maxCorner = minCorner + iSize;
	}
	
	inline bool AABoxf::operator==(const AABoxf& iOther) const
	{
		return (minCorner == iOther.minCorner) && (maxCorner == iOther.maxCorner);
	}
	
	inline bool AABoxf::operator!=(const AABoxf& iOther) const
	{
		return (minCorner != iOther.minCorner) || (maxCorner != iOther.maxCorner);
	}
	
	template <typename TVertex> inline void AABoxf::vertices(TVertex* oVertices) const
	{
		Vector3f* pts = &oVertices->position;
		const size_t stride = sizeof(TVertex);
		
		points(pts, stride);
	}
	
	inline bool AABoxf::contains(const Vector3f& iPoint) const
	{
		if (iPoint.x < minCorner.x)
			return false;

		if (iPoint.y < minCorner.y)
			return false;

		if (iPoint.z < minCorner.z)
			return false;

		if (iPoint.x > maxCorner.x)
			return false;

		if (iPoint.y > maxCorner.y)
			return false;
		
		if (iPoint.z > maxCorner.z)
			return false;
		
		return true;
	}
}

#endif // _AABoxf_H_