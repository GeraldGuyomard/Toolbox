/*
 *  AABoxf.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "AABoxf.h"
#include "StridedPtr.h"
#include "Matrix44f.h"
#include "Vertex.h"

#include <cfloat>

namespace Toolbox
{
		
void
AABoxf::points(Vector3f* oVertices, size_t iStride) const
{
	StridedPtr<Vector3f> v(oVertices, iStride);
	
	// Far Plane
	v[0].setCoordinates(minCorner.x, maxCorner.y, minCorner.z);
	v[1].setCoordinates(minCorner.x, minCorner.y, minCorner.z);
	v[2].setCoordinates(maxCorner.x, minCorner.y, minCorner.z);
	v[3].setCoordinates(maxCorner.x, maxCorner.y, minCorner.z);

	// Near Plane
	v[4].setCoordinates(minCorner.x, maxCorner.y, maxCorner.z);
	v[5].setCoordinates(minCorner.x, minCorner.y, maxCorner.z);
	v[6].setCoordinates(maxCorner.x, minCorner.y, maxCorner.z);
	v[7].setCoordinates(maxCorner.x, maxCorner.y, maxCorner.z);
}

Vector3f AABoxf::point(Uint32 iPointIndex) const
{
	TB_ASSERT(iPointIndex < 8);
	
	switch(iPointIndex)
	{
		// Far Plane
		case 0:	return Vector3f(minCorner.x, maxCorner.y, minCorner.z);
		case 1: return Vector3f(minCorner.x, minCorner.y, minCorner.z);
		case 2: return Vector3f(maxCorner.x, minCorner.y, minCorner.z);
		case 3: return Vector3f(maxCorner.x, maxCorner.y, minCorner.z);
		
		// Near Plane
		case 4: return Vector3f(minCorner.x, maxCorner.y, maxCorner.z);
		case 5: return Vector3f(minCorner.x, minCorner.y, maxCorner.z);
		case 6: return Vector3f(maxCorner.x, minCorner.y, maxCorner.z);
		case 7: return Vector3f(maxCorner.x, maxCorner.y, maxCorner.z);	
	}
	
	return Vector3f::kNull;
}
	
void
AABoxf::pointIndicesOfPlane(EPlaneID iPlaneID, Uint32 oIndices[4])
{
	TB_ASSERT(iPlaneID < ePlaneCount);
	
	switch(iPlaneID)
	{
		case eBackPlane:
		{
			oIndices[0] = 0;
			oIndices[1] = 1;
			oIndices[2] = 2;
			oIndices[3] = 3;
			break;
		}
			
		case eFrontPlane:
		{
			oIndices[0] = 4;
			oIndices[1] = 5;
			oIndices[2] = 6;
			oIndices[3] = 7;
			break;
		}
			
		case eLeftPlane:
		{
			oIndices[0] = 0;
			oIndices[1] = 1;
			oIndices[2] = 5;
			oIndices[3] = 4;
			break;
		}
			
		case eRightPlane:
		{
			oIndices[0] = 3;
			oIndices[1] = 2;
			oIndices[2] = 6;
			oIndices[3] = 7;
			break;
		}
			
		case eBottomPlane:
		{
			oIndices[0] = 1;
			oIndices[1] = 5;
			oIndices[2] = 6;
			oIndices[3] = 2;
			break;
		}
			
		case eTopPlane:
		{
			oIndices[0] = 0;
			oIndices[1] = 4;
			oIndices[2] = 7;
			oIndices[3] = 3;
			break;
		}
			
		default:
		{
			TB_ASSERT(false);
		}
	}	
}
	
void
AABoxf::pointsOfPlane(EPlaneID iPlaneID, Vector3f* oPoints, size_t iStride) const
{
	TB_ASSERT(iPlaneID < ePlaneCount);
	StridedPtr<Vector3f> v(oPoints, iStride);
	
	switch(iPlaneID)
	{
		case eBackPlane:
		{
			v[0].setCoordinates(minCorner.x, maxCorner.y, minCorner.z);
			v[1] = minCorner;
			v[2].setCoordinates(maxCorner.x, minCorner.y, minCorner.z);
			v[3].setCoordinates(maxCorner.x, maxCorner.y, minCorner.z);
			break;
		}

		case eFrontPlane:
		{
			v[0].setCoordinates(minCorner.x, maxCorner.y, maxCorner.z);
			v[1].setCoordinates(minCorner.x, minCorner.y, maxCorner.z);
			v[2].setCoordinates(maxCorner.x, minCorner.y, maxCorner.z);
			v[3] = maxCorner;
			break;
		}
			
		case eLeftPlane:
		{
			v[0].setCoordinates(minCorner.x, maxCorner.y, minCorner.z);
			v[1] = minCorner;
			v[2].setCoordinates(minCorner.x, minCorner.y, maxCorner.z);
			v[3].setCoordinates(minCorner.x, maxCorner.y, maxCorner.z);
			break;
		}
			
		case eRightPlane:
		{
			v[0] = maxCorner;
			v[1].setCoordinates(maxCorner.x, minCorner.y, maxCorner.z);
			v[2].setCoordinates(maxCorner.x, minCorner.y, minCorner.z);
			v[3].setCoordinates(maxCorner.x, maxCorner.y, minCorner.z);
			break;
		}
			
		case eBottomPlane:
		{
			v[0] = minCorner;
			v[1].setCoordinates(minCorner.x, minCorner.y, maxCorner.z);
			v[2].setCoordinates(maxCorner.x, minCorner.y, maxCorner.z);
			v[3].setCoordinates(maxCorner.x, minCorner.y, minCorner.z);
			break;
		}
			
		case eTopPlane:
		{
			v[0].setCoordinates(minCorner.x, maxCorner.y, minCorner.z);
			v[1].setCoordinates(minCorner.x, maxCorner.y, maxCorner.z);
			v[2] = maxCorner;
			v[3].setCoordinates(maxCorner.x, maxCorner.y, minCorner.z);
			break;
		}
			
		default:
		{
			TB_ASSERT(false);
		}
	}
}
	
void
AABoxf::setEmpty()
{
	minCorner.setCoordinates(FLT_MAX, FLT_MAX, FLT_MAX);
	maxCorner.setCoordinates(-FLT_MAX, -FLT_MAX, -FLT_MAX);
}
	
void
AABoxf::add(const Vector3f& iPoint)
{
	if (iPoint.x < minCorner.x)
	{
		minCorner.x = iPoint.x;
	}
	
	// No else if to handle the case
	// of empty box degenerated to one point
	if (iPoint.x > maxCorner.x)
	{
		maxCorner.x = iPoint.x;
	}
	
	if (iPoint.y < minCorner.y)
	{
		minCorner.y = iPoint.y;
	}
	
	if (iPoint.y > maxCorner.y)
	{
		maxCorner.y = iPoint.y;
	}
	
	if (iPoint.z < minCorner.z)
	{
		minCorner.z = iPoint.z;
	}
	
	if (iPoint.z > maxCorner.z)
	{
		maxCorner.z = iPoint.z;
	}
}

void
AABoxf::add(const AABoxf& iOther)
{
	TB_ASSERT(&iOther != this);
	
	// minimum
	if (iOther.minCorner.x < minCorner.x)
	{
		minCorner.x = iOther.minCorner.x;
	}
	
	if (iOther.minCorner.y < minCorner.y)
	{
		minCorner.y = iOther.minCorner.y;
	}
	
	if (iOther.minCorner.z < minCorner.z)
	{
		minCorner.z = iOther.minCorner.z;
	}
	
	// maximum
	if (iOther.maxCorner.x > maxCorner.x)
	{
		maxCorner.x = iOther.maxCorner.x;
	}
	
	if (iOther.maxCorner.y > maxCorner.y)
	{
		maxCorner.y = iOther.maxCorner.y;
	}
	
	if (iOther.maxCorner.z > maxCorner.z)
	{
		maxCorner.z = iOther.maxCorner.z;
	}
}

void
AABoxf::transformBy(const Matrix44f& iMatrix, AABoxf& oBox) const
{
	VertexP points[8];
	vertices(points);
	
	oBox.setEmpty();
	VertexP p;
	for(int i=0; i < 8; ++i)
	{
		points[i].transformBy(iMatrix, p);
		oBox.add(p.position);
	}
}
	
void
AABoxf::planes(Plane3D oPlanes[ePlaneCount]) const
{
	// Front / Back
	oPlanes[eBackPlane].createWithNormalAndPoint(Vector3f(0, 0, -1), 	minCorner);
	oPlanes[eFrontPlane].createWithNormalAndPoint(Vector3f(0, 0, +1), 	maxCorner);
	
	// Left / Right
	oPlanes[eLeftPlane].createWithNormalAndPoint(Vector3f(-1, 0, 0), 	minCorner);
	oPlanes[eRightPlane].createWithNormalAndPoint(Vector3f(+1, 0, 0), 	maxCorner);
	
	// Bottom / Top
	oPlanes[eBottomPlane].createWithNormalAndPoint(Vector3f(0, -1, 0), 	minCorner);
	oPlanes[eTopPlane].createWithNormalAndPoint(Vector3f(0, +1, 0), 	maxCorner);
}
	
	
} // End of toolbox