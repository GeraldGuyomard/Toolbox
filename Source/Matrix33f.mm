/*
 *  Matrix33f.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Matrix33f.h"
#include "Vector3f.h"
#include "MathTools.h"
#include "AAboxf.h"
#include "StridedPtr.h"

namespace Toolbox
{
	
const Matrix33f Matrix33f::kIdentityMatrix(	1.f, 0.f, 0.f,
											0.f, 1.f, 0.f,
									 		0.f, 0.f, 1.f);

Matrix33f::Matrix33f(Float32 v11, Float32 v12, Float32 v13,
					Float32 v21, Float32 v22, Float32 v23,
					Float32 v31, Float32 v32, Float32 v33)
{
	// First Row
	value[0][0] = v11;
	value[0][1] = v12;
	value[0][2] = v13;
	
	// Second Row
	value[1][0] = v21;
	value[1][1] = v22;
	value[1][2] = v23;
	
	// Third Row
	value[2][0] = v31;
	value[2][1] = v32;
	value[2][2] = v33;
}

void Matrix33f::transpose(Matrix33f& oTranspose) const
{
	TB_ASSERT(this != &oTranspose);
	
	// Diagonal
	oTranspose.value[0][0] = value[0][0];
	oTranspose.value[1][1] = value[1][1];
	oTranspose.value[2][2] = value[2][2];
	
	// Symmetry
	oTranspose.value[1][0] = value[0][1];
	oTranspose.value[2][0] = value[0][2];

	oTranspose.value[0][1] = value[1][0];
	oTranspose.value[2][1] = value[1][2];

	oTranspose.value[0][2] = value[2][0];
	oTranspose.value[1][2] = value[2][1];
}
	
void Matrix33f::setTranslation(const Vector2f& iTranslation)
{
	value[2][0] = iTranslation.x;
	value[2][1] = iTranslation.y;
	value[2][2] = 1.f;
}

void Matrix33f::translate(const Vector2f& iTranslation)
{
	Vector2f& position = row(2);
	position += iTranslation;
}

void Matrix33f::createScale(const Vector2f& iScale)
{
	value[0][0] = iScale.x;
	value[0][1] = 0.f;
	value[0][2] = 0.f;
	
	value[1][0] = 0.f;
	value[1][1] = iScale.y;
	value[1][2] = 0.f;
	
	value[2][0] = 0.f;
	value[2][1] = 0.f;
	value[2][2] = 1.f;	
}
	
void Matrix33f::scale(const Vector2f& iScale)
{
	value[0][0] *= iScale.x;
	value[1][1] *= iScale.y;
}
	

Matrix33f
operator*(const Matrix33f& iM1, const Matrix33f& iM2)
{
	Matrix33f m;
	
	// row 0
	m.value[0][0] = (iM1.value[0][0] * iM2.value[0][0]) + (iM1.value[0][1] * iM2.value[1][0]) + (iM1.value[0][2] * iM2.value[2][0]) ;
	m.value[0][1] = (iM1.value[0][0] * iM2.value[0][1]) + (iM1.value[0][1] * iM2.value[1][1]) + (iM1.value[0][2] * iM2.value[2][1]) ;
	m.value[0][2] = (iM1.value[0][0] * iM2.value[0][2]) + (iM1.value[0][1] * iM2.value[1][2]) + (iM1.value[0][2] * iM2.value[2][2]) ;
	
	// row 1
	m.value[1][0] = (iM1.value[1][0] * iM2.value[0][0]) + (iM1.value[1][1] * iM2.value[1][0]) + (iM1.value[1][2] * iM2.value[2][0]) ;
	m.value[1][1] = (iM1.value[1][0] * iM2.value[0][1]) + (iM1.value[1][1] * iM2.value[1][1]) + (iM1.value[1][2] * iM2.value[2][1]) ;
	m.value[1][2] = (iM1.value[1][0] * iM2.value[0][2]) + (iM1.value[1][1] * iM2.value[1][2]) + (iM1.value[1][2] * iM2.value[2][2]) ;

	// row 2
	m.value[2][0] = (iM1.value[2][0] * iM2.value[0][0]) + (iM1.value[2][1] * iM2.value[1][0]) + (iM1.value[2][2] * iM2.value[2][0]) ;
	m.value[2][1] = (iM1.value[2][0] * iM2.value[0][1]) + (iM1.value[2][1] * iM2.value[1][1]) + (iM1.value[2][2] * iM2.value[2][1]) ;
	m.value[2][2] = (iM1.value[2][0] * iM2.value[0][2]) + (iM1.value[2][1] * iM2.value[1][2]) + (iM1.value[2][2] * iM2.value[2][2]) ;

	return m;
}

void Matrix33f::transformPoint(const Vector2f& iPoint, Vector2f& oPoint) const
{
	Vector2f transformedP; // to allow iPoint = oPoint
	
	transformedP.x = (value[0][0] * iPoint.x) + (value[1][0] * iPoint.y) + value[2][0];
	transformedP.y = (value[0][1] * iPoint.x) + (value[1][1] * iPoint.y) + value[2][1];
	
	const Float32 w = (value[0][2] * iPoint.x) + (value[1][2] * iPoint.y) + value[2][2];
	
	transformedP.x /= w;
	transformedP.y /= w;
	
	oPoint = transformedP;
}

void Matrix33f::transform(const Vector3f& iVectorOrPoint, Vector3f& oVectorOrPoint) const
{
	Vector3f transformedVP; // to allow iVectorOrPoint = oVectorOrPoint
	
	transformedVP.x = (value[0][0] * iVectorOrPoint.x) + (value[1][0] * iVectorOrPoint.y) + (value[2][0] * iVectorOrPoint.z);
	transformedVP.y = (value[0][1] * iVectorOrPoint.x) + (value[1][1] * iVectorOrPoint.y) + (value[2][1] * iVectorOrPoint.z);
	transformedVP.z = (value[0][2] * iVectorOrPoint.x) + (value[1][2] * iVectorOrPoint.y) + (value[2][2] * iVectorOrPoint.z);
	
	oVectorOrPoint = transformedVP;
}
	
void Matrix33f::transformPoints(const Vector2f* iPoints, Uint32 iCount, Vector2f* oPoints, size_t iStrideIn, size_t iStrideOut) const
{	
	StridedPtr<Vector2f> vIn(iPoints, iStrideIn);
	StridedPtr<Vector2f> vOut(oPoints, iStrideOut);
	
	for (Uint32 i=0; i < iCount; ++i, ++vIn, ++vOut)
	{
		const Vector2f& p3D = *vIn;

		Vector2f p2D;
		p2D.x = (value[0][0] * p3D.x) + (value[1][0] * p3D.y) + value[2][0];
		p2D.y = (value[0][1] * p3D.x) + (value[1][1] * p3D.y) + value[2][1];
		
		const Float32 w = (value[0][2] * p3D.x) + (value[1][2] * p3D.y) + value[2][2];
				
		p2D.x /= w;
		p2D.y /= w;
		
		*vOut = p2D;
	}
}
	
	
Float32 Matrix33f::linearDeterminant() const
{
	return (value[0][0] * value[1][1]) - (value[1][0] * value[0][1]); 
}
	
void Matrix33f::createTranslation(const Vector2f& iTranslation)
{
	value[0][0] = 1.f;
	value[0][1] = 0.f;
	value[0][2] = 0.f;

	value[1][0] = 0.f;
	value[1][1] = 1.f;
	value[1][2] = 0.f;
	
	
	row(2) = iTranslation;
	value[2][2] = 1.f;
}
	
} // end of Toolbox