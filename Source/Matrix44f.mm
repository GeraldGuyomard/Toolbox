/*
 *  Matrix44f.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Matrix44f.h"
#include "Vector3f.h"
#include "MathTools.h"
#include "AAboxf.h"
#include "StridedPtr.h"

namespace Toolbox
{
	
const Matrix44f Matrix44f::kIdentityMatrix(	1.f, 0.f, 0.f, 0.f,
											0.f, 1.f, 0.f, 0.f,
									 		0.f, 0.f, 1.f, 0.f,
									 		0.f, 0.f, 0.f, 1.f);

Matrix44f::Matrix44f(Float32 v11, Float32 v12, Float32 v13, Float32 v14,
			  		Float32 v21, Float32 v22, Float32 v23, Float32 v24,
			  		Float32 v31, Float32 v32, Float32 v33, Float32 v34,
			  		Float32 v41, Float32 v42, Float32 v43, Float32 v44)
{
	// First Row
	value[0][0] = v11;
	value[0][1] = v12;
	value[0][2] = v13;
	value[0][3] = v14;
	
	// Second Row
	value[1][0] = v21;
	value[1][1] = v22;
	value[1][2] = v23;
	value[1][3] = v24;
	
	// Third Row
	value[2][0] = v31;
	value[2][1] = v32;
	value[2][2] = v33;
	value[2][3] = v34;
	
	// Fourth Row
	value[3][0] = v41;
	value[3][1] = v42;
	value[3][2] = v43;
	value[3][3] = v44;
}

void Matrix44f::transpose(Matrix44f& oTranspose) const
{
	TB_ASSERT(this != &oTranspose);
	
	// Diagonal
	oTranspose.value[0][0] = value[0][0];
	oTranspose.value[1][1] = value[1][1];
	oTranspose.value[2][2] = value[2][2];
	oTranspose.value[3][3] = value[3][3];
	
	// Symmetry
	oTranspose.value[1][0] = value[0][1];
	oTranspose.value[2][0] = value[0][2];
	oTranspose.value[3][0] = value[0][3];

	oTranspose.value[0][1] = value[1][0];
	oTranspose.value[2][1] = value[1][2];
	oTranspose.value[3][1] = value[1][3];

	oTranspose.value[0][2] = value[2][0];
	oTranspose.value[1][2] = value[2][1];
	oTranspose.value[3][2] = value[2][3];
	
	oTranspose.value[0][3] = value[3][0];
	oTranspose.value[1][3] = value[3][1];
	oTranspose.value[2][3] = value[3][2];
}
	
void Matrix44f::setTranslation(const Vector3f& iTranslation)
{
	value[3][0] = iTranslation.x;
	value[3][1] = iTranslation.y;
	value[3][2] = iTranslation.z;
	value[3][3] = 1.f;
}

void Matrix44f::translate(const Vector3f& iTranslation)
{
	Vector3f& position = row(3);
	position += iTranslation;
}

void Matrix44f::scale(const Vector3f& iScale)
{
	value[0][0] *= iScale.x;
	value[1][1] *= iScale.y;
	value[2][2] *= iScale.z;
}
	
void
Matrix44f::setDirectionAndUp(const Vector3f& iDirection, const Vector3f& iUp)
{
	Vector3f z = iDirection;
	z.normalize();
	
	Vector3f y = iUp;
	y.normalize();
	
	Vector3f x = y ^ z;
	
	value[0][0] = x.x;
	value[0][1] = x.y;
	value[0][2] = x.z;
	
	value[1][0] = y.x;
	value[1][1] = y.y;
	value[1][2] = y.z;

	value[2][0] = z.x;
	value[2][1] = z.y;
	value[2][2] = z.z;
}


Matrix44f
operator*(const Matrix44f& iM1, const Matrix44f& iM2)
{
	Matrix44f m;
	
	// row 0
	m.value[0][0] = (iM1.value[0][0] * iM2.value[0][0]) + (iM1.value[0][1] * iM2.value[1][0]) + (iM1.value[0][2] * iM2.value[2][0]) + (iM1.value[0][3] * iM2.value[3][0]);
	m.value[0][1] = (iM1.value[0][0] * iM2.value[0][1]) + (iM1.value[0][1] * iM2.value[1][1]) + (iM1.value[0][2] * iM2.value[2][1]) + (iM1.value[0][3] * iM2.value[3][1]);
	m.value[0][2] = (iM1.value[0][0] * iM2.value[0][2]) + (iM1.value[0][1] * iM2.value[1][2]) + (iM1.value[0][2] * iM2.value[2][2]) + (iM1.value[0][3] * iM2.value[3][2]);
	m.value[0][3] = (iM1.value[0][0] * iM2.value[0][3]) + (iM1.value[0][1] * iM2.value[1][3]) + (iM1.value[0][2] * iM2.value[2][3]) + (iM1.value[0][3] * iM2.value[3][3]);
	
	// row 1
	m.value[1][0] = (iM1.value[1][0] * iM2.value[0][0]) + (iM1.value[1][1] * iM2.value[1][0]) + (iM1.value[1][2] * iM2.value[2][0]) + (iM1.value[1][3] * iM2.value[3][0]);
	m.value[1][1] = (iM1.value[1][0] * iM2.value[0][1]) + (iM1.value[1][1] * iM2.value[1][1]) + (iM1.value[1][2] * iM2.value[2][1]) + (iM1.value[1][3] * iM2.value[3][1]);
	m.value[1][2] = (iM1.value[1][0] * iM2.value[0][2]) + (iM1.value[1][1] * iM2.value[1][2]) + (iM1.value[1][2] * iM2.value[2][2]) + (iM1.value[1][3] * iM2.value[3][2]);
	m.value[1][3] = (iM1.value[1][0] * iM2.value[0][3]) + (iM1.value[1][1] * iM2.value[1][3]) + (iM1.value[1][2] * iM2.value[2][3]) + (iM1.value[1][3] * iM2.value[3][3]);

	// row 2
	m.value[2][0] = (iM1.value[2][0] * iM2.value[0][0]) + (iM1.value[2][1] * iM2.value[1][0]) + (iM1.value[2][2] * iM2.value[2][0]) + (iM1.value[2][3] * iM2.value[3][0]);
	m.value[2][1] = (iM1.value[2][0] * iM2.value[0][1]) + (iM1.value[2][1] * iM2.value[1][1]) + (iM1.value[2][2] * iM2.value[2][1]) + (iM1.value[2][3] * iM2.value[3][1]);
	m.value[2][2] = (iM1.value[2][0] * iM2.value[0][2]) + (iM1.value[2][1] * iM2.value[1][2]) + (iM1.value[2][2] * iM2.value[2][2]) + (iM1.value[2][3] * iM2.value[3][2]);
	m.value[2][3] = (iM1.value[2][0] * iM2.value[0][3]) + (iM1.value[2][1] * iM2.value[1][3]) + (iM1.value[2][2] * iM2.value[2][3]) + (iM1.value[2][3] * iM2.value[3][3]);

	// row 3
	m.value[3][0] = (iM1.value[3][0] * iM2.value[0][0]) + (iM1.value[3][1] * iM2.value[1][0]) + (iM1.value[3][2] * iM2.value[2][0]) + (iM1.value[3][3] * iM2.value[3][0]);
	m.value[3][1] = (iM1.value[3][0] * iM2.value[0][1]) + (iM1.value[3][1] * iM2.value[1][1]) + (iM1.value[3][2] * iM2.value[2][1]) + (iM1.value[3][3] * iM2.value[3][1]);
	m.value[3][2] = (iM1.value[3][0] * iM2.value[0][2]) + (iM1.value[3][1] * iM2.value[1][2]) + (iM1.value[3][2] * iM2.value[2][2]) + (iM1.value[3][3] * iM2.value[3][2]);
	m.value[3][3] = (iM1.value[3][0] * iM2.value[0][3]) + (iM1.value[3][1] * iM2.value[1][3]) + (iM1.value[3][2] * iM2.value[2][3]) + (iM1.value[3][3] * iM2.value[3][3]);
	
	return m;
}

void Matrix44f::transformPoint(const Vector3f& iPoint, Vector3f& oPoint) const
{
	Vector3f transformedP; // to allow iPoint = oPoint
	
	transformedP.x = (value[0][0] * iPoint.x) + (value[1][0] * iPoint.y) + (value[2][0] * iPoint.z) + value[3][0];
	transformedP.y = (value[0][1] * iPoint.x) + (value[1][1] * iPoint.y) + (value[2][1] * iPoint.z) + value[3][1];
	transformedP.z = (value[0][2] * iPoint.x) + (value[1][2] * iPoint.y) + (value[2][2] * iPoint.z) + value[3][2];
	
	const Float32 w = (value[0][3] * iPoint.x) + (value[1][3] * iPoint.y) + (value[2][3] * iPoint.z) + value[3][3];
	
	transformedP.x /= w;
	transformedP.y /= w;
	transformedP.z /= w;
	
	oPoint = transformedP;
}

void Matrix44f::transform(const Vector4f& iVectorOrPoint, Vector4f& oVectorOrPoint) const
{
	Vector4f transformedVP; // to allow iVectorOrPoint = oVectorOrPoint
	
	transformedVP.x = (value[0][0] * iVectorOrPoint.x) + (value[1][0] * iVectorOrPoint.y) + (value[2][0] * iVectorOrPoint.z) + (value[3][0] * iVectorOrPoint.w);
	transformedVP.y = (value[0][1] * iVectorOrPoint.x) + (value[1][1] * iVectorOrPoint.y) + (value[2][1] * iVectorOrPoint.z) + (value[3][1] * iVectorOrPoint.w);
	transformedVP.z = (value[0][2] * iVectorOrPoint.x) + (value[1][2] * iVectorOrPoint.y) + (value[2][2] * iVectorOrPoint.z) + (value[3][2] * iVectorOrPoint.w);
	transformedVP.w = (value[0][3] * iVectorOrPoint.x) + (value[1][3] * iVectorOrPoint.y) + (value[2][3] * iVectorOrPoint.z) + (value[3][3] * iVectorOrPoint.w);
	
	oVectorOrPoint = transformedVP;
}
	
void Matrix44f::transformPoints(const Vector3f* iPoints, Uint32 iCount, Vector3f* oPoints, size_t iStrideIn, size_t iStrideOut) const
{	
	StridedPtr<Vector3f> vIn(iPoints, iStrideIn);
	StridedPtr<Vector3f> vOut(oPoints, iStrideOut);
	
	for (Uint32 i=0; i < iCount; ++i, ++vIn, ++vOut)
	{
		const Vector3f& p3D = *vIn;

		Vector3f p2D;
		p2D.x = (value[0][0] * p3D.x) + (value[1][0] * p3D.y) + (value[2][0] * p3D.z) + value[3][0];
		p2D.y = (value[0][1] * p3D.x) + (value[1][1] * p3D.y) + (value[2][1] * p3D.z) + value[3][1];
		p2D.z = (value[0][2] * p3D.x) + (value[1][2] * p3D.y) + (value[2][2] * p3D.z) + value[3][2];
		
		const Float32 w = (value[0][3] * p3D.x) + (value[1][3] * p3D.y) + (value[2][3] * p3D.z) + value[3][3];
		
		p2D.x /= w;
		p2D.y /= w;
		p2D.z /= w;
		
		*vOut = p2D;
	}
}
	
void Matrix44f::affineTransformVector(const Vector3f& iVector, Vector3f& oVector) const
{
	TB_ASSERT(isAffine());
	
	Vector3f transformedV; // to allow iVector = oVector
	
	transformedV.x = (value[0][0] * iVector.x) + (value[1][0] * iVector.y) + (value[2][0] * iVector.z);
	transformedV.y = (value[0][1] * iVector.x) + (value[1][1] * iVector.y) + (value[2][1] * iVector.z);
	transformedV.z = (value[0][2] * iVector.x) + (value[1][2] * iVector.y) + (value[2][2] * iVector.z);
	
	oVector = transformedV;
	
}
	
Float32 Matrix44f::linearDeterminant() const
{
	return (value[0][0] * (value[1][1] * value[2][2] - value[1][2] * value[2][1]) + value[0][1] * (value[1][2] * value[2][0] - value[1][0] * value[2][2]) + value[0][2] * (value[1][0] * value[2][1] - value[1][1] * value[2][0])) ;
}
		
bool Matrix44f::inverseAffine(Matrix44f& oInverse) const
{
	TB_ASSERT(this != &oInverse);
	TB_ASSERT(isAffineNormalized());
	
	// Invertible is det != 0
	const Float32 det = linearDeterminant();
	
	// Is Singular ? 
	if (isNearZero(det))
	{
		return false;
	}
	
	// Apply Cramer Formular on 3x3 matrix
	const Float32 invDet = 1.f / det;
	const Float32 minusInvDet = -invDet;
	
	oInverse.value[0][0] = invDet 		* ((value[1][1] * value[2][2]) - (value[1][2] * value[2][1]));
	oInverse.value[2][0] = invDet 		* ((value[1][0] * value[2][1]) - (value[1][1] * value[2][0]));
	oInverse.value[1][1] = invDet 		* ((value[0][0] * value[2][2]) - (value[0][2] * value[2][0]));
	oInverse.value[0][2] = invDet 		* ((value[0][1] * value[1][2]) - (value[0][2] * value[1][1]));
	oInverse.value[2][2] = invDet 		* ((value[0][0] * value[1][1]) - (value[0][1] * value[1][0]));
	
	oInverse.value[1][0] = minusInvDet	* ((value[1][0] * value[2][2]) - (value[1][2] * value[2][0]));
	oInverse.value[0][1] = minusInvDet	* ((value[0][1] * value[2][2]) - (value[0][2] * value[2][1]));
	oInverse.value[2][1] = minusInvDet	* ((value[0][0] * value[2][1]) - (value[0][1] * value[2][0]));
	oInverse.value[1][2] = minusInvDet	* ((value[0][0] * value[1][2]) - (value[0][2] * value[1][0]));
	
	oInverse.value[0][3] = 0.f;
	oInverse.value[1][3] = 0.f;
	oInverse.value[2][3] = 0.f;
	
	// apply inverse translation
	oInverse.value[3][0] = -((oInverse.value[0][0] * value[3][0]) + (oInverse.value[1][0] * value[3][1]) + (oInverse.value[2][0] * value[3][2]));
	oInverse.value[3][1] = -((oInverse.value[0][1] * value[3][0]) + (oInverse.value[1][1] * value[3][1]) + (oInverse.value[2][1] * value[3][2]));
	oInverse.value[3][2] = -((oInverse.value[0][2] * value[3][0]) + (oInverse.value[1][2] * value[3][1]) + (oInverse.value[2][2] * value[3][2]));
	oInverse.value[3][3] = 1.f;
	
	return true;
}

void Matrix44f::createTranslation(const Vector3f& iTranslation)
{
	value[0][0] = 1.f;
	value[0][1] = 0.f;
	value[0][2] = 0.f;
	value[0][3] = 0.f;

	value[1][0] = 0.f;
	value[1][1] = 1.f;
	value[1][2] = 0.f;
	value[1][3] = 0.f;
	
	value[2][0] = 0.f;
	value[2][1] = 0.f;
	value[2][2] = 1.f;
	value[2][3] = 0.f;
	
	row(3) = iTranslation;
	value[3][3] = 1.f;
}
	
void Matrix44f::createScale(const Vector3f& iScale)
{
	value[0][0] = iScale.x;
	value[0][1] = 0.f;
	value[0][2] = 0.f;
	value[0][3] = 0.f;
	
	value[1][0] = 0.f;
	value[1][1] = iScale.y;
	value[1][2] = 0.f;
	value[1][3] = 0.f;
	
	value[2][0] = 0.f;
	value[2][1] = 0.f;
	value[2][2] = iScale.z;
	value[2][3] = 0.f;	
	
	value[3][0] = 0.f;
	value[3][1] = 0.f;
	value[3][2] = 0.f;
	value[3][3] = 1.f;
}

void Matrix44f::createScale(const Vector3f& iScale, const Vector3f& iCenter)
{
	// TO OPTIMIZE
	// S (s, t) = T(-t) * S * T(t)
	// 
	createScale(iScale);
	
	Matrix44f translation;
	translation.createTranslation(iCenter);
	
	*this *= translation;
	
	translation.setTranslation(-iCenter);
	*this = translation * *this;
}

void Matrix44f::createRotation(float iAngleInRad, const Vector3f& iAxis)
{
	Vector3f A = iAxis;
	A.normalize();
	
	// see Book "Mathematics for 3D Game Programming and Computer Graphics, p. 80
	const Float32 c = cosf(iAngleInRad);
	const Float32 s = sinf(iAngleInRad);
	const Float32 oneMinusC = 1.f - c;
		
	const Float32 oneMinusCAxAy = oneMinusC * A.x * A.y;
	const Float32 oneMinusCAxAz = oneMinusC * A.x * A.z;
	const Float32 oneMinusCAyAz = oneMinusC * A.y * A.z;
	
	const Float32 sAx = s * A.x;
	const Float32 sAy = s * A.y;
	const Float32 sAz = s * A.z;
	
	value[0][0] = c + (oneMinusC * A.x * A.x);
	value[0][1] = oneMinusCAxAy + sAz;
	value[0][2] = oneMinusCAxAz - sAy;
	value[0][3] = 0.f;
	
	value[1][0] = oneMinusCAxAy - sAz;
	value[1][1] = c + (oneMinusC * A.y * A.y);
	value[1][2] = oneMinusCAyAz + sAx;
	value[1][3] = 0.f;
	
	value[2][0] = oneMinusCAxAz  + sAy;
	value[2][1] = oneMinusCAyAz - sAx;
	value[2][2] = c + (oneMinusC * A.z * A.z);
	value[2][3] = 0.f;
	
	value[3][0] = 0.f;
	value[3][1] = 0.f;
	value[3][2] = 0.f;
	value[3][3] = 1.f;
	
}
	
void Matrix44f::createRotation(float iAngleInRad, const Vector3f& iAxis, const Vector3f& iCenter)
{
	createTranslation(-iCenter);
	
	Matrix44f rot;
	rot.createRotation(iAngleInRad, iAxis);
	
	*this *= rot;
	
	translate(iCenter);
}
	
} // end of Toolbox