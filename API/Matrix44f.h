/*
 *  Matrix44f.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Matrix44f_H_)
#define _Matrix44f_H_

#include "BasicTypes.h"
#include "Vector3f.h"
#include "Vector4f.h"
#include "TVector2.h"

namespace Toolbox
{	
	// Row based vector
	// to be ready to use for GL calls
	// Then do not forget that f(g(x)) = G * F in this situation !
	class Matrix44f
	{
	public:
		union
		{
			Float32 value[4][4];	
			Float32 array[4 * 4];
		};
		
	public:
		
		static const Matrix44f kIdentityMatrix;
		
		Matrix44f();
		Matrix44f(Float32 v11, Float32 v12, Float32 v13, Float32 v14,
				  Float32 v21, Float32 v22, Float32 v23, Float32 v24,
				  Float32 v31, Float32 v32, Float32 v33, Float32 v34,
				  Float32 v41, Float32 v42, Float32 v43, Float32 v44);
		
		Vector3f& row(Uint32 iIndex);
		const Vector3f& row(Uint32 iIndex) const;
		
		const Vector3f& direction() const;
		const Vector3f& right() const;
		const Vector3f& up() const;
		const Vector3f& translation() const;
		
		void setTranslation(const Vector3f& iTranslation);
		void setDirectionAndUp(const Vector3f& iDirection, const Vector3f& iUp);
		
		Matrix44f& operator*=(const Matrix44f& iOther);
		
		void translate(const Vector3f& iTranslation);
		void scale(const Vector3f& iScale);
		
		bool isAffine() const;
		bool isAffineNormalized() const;
		
		// oTranspose cannot be this
		void transpose(Matrix44f& oTranspose) const;
		
		Float32 linearDeterminant() const;
		bool inverseAffine(Matrix44f& oInverse) const;
		
		void transformPoints(const Vector3f* iPoints, Uint32 iCount, Vector3f* oPoints, size_t iStrideIn = sizeof(Vector3f), size_t iStrideOut = sizeof(Vector3f)) const;
		void transformPoint(const Vector3f& iPoint, Vector3f& oPoint) const;
		
		// Only works with affine matrices
		void affineTransformVector(const Vector3f& iVector, Vector3f& oVector) const;

		void transform(const Vector4f& iVectorOrPoint, Vector4f& oVectorOrPoint) const;
		
		// Set this matrix to a characteristical transform
		void createTranslation(const Vector3f& iTranslation);
		
		void createScale(const Vector3f& iScale);
		void createScale(const Vector3f& iScale, const Vector3f& iCenter);
		
		void createRotation(float iAngleInRad, const Vector3f& iAxis);
		void createRotation(float iAngleInRad, const Vector3f& iAxis, const Vector3f& iCenter);
	};
	
	Matrix44f operator*(const Matrix44f& iM1, const Matrix44f& iM2);
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline Matrix44f::Matrix44f() {}
	
	inline Vector3f& Matrix44f::row(Uint32 iIndex)
	{
		TB_ASSERT(iIndex <= 3);
		return (Vector3f&) value[iIndex][0];
	}

	inline const Vector3f& Matrix44f::row(Uint32 iIndex) const
	{
		TB_ASSERT(iIndex <= 3);
		return (const Vector3f&) value[iIndex];
	}
	
	inline bool Matrix44f::isAffine() const
	{
		return (value[0][3]== 0.f) && (value[1][3]== 0.f) && (value[2][3]== 0.f);
	}

	inline bool Matrix44f::isAffineNormalized() const
	{
		return (value[0][3]== 0.f) && (value[1][3]== 0.f) && (value[2][3]== 0.f) && (value[3][3] == 1.f);
	}
	
	inline Matrix44f&
	Matrix44f::operator*=(const Matrix44f& iOther)
	{
		*this = *this * iOther;
		return *this;
	}
	
	inline const Vector3f&
	Matrix44f::direction() const
	{
		return row(2); // z is mapped on direction
	}
	
	inline const Vector3f& Matrix44f::right() const
	{
		return row(0);
	}
	
	inline const Vector3f& Matrix44f::up() const
	{
		return row(1);
	}
	
	inline const Vector3f&
	Matrix44f::translation() const
	{
		return row(3);
	}
}

#endif // _Matrix44f_H_