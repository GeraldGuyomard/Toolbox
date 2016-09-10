/*
 *  Matrix33f.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Matrix33f_H_)
#define _Matrix33f_H_

#include "BasicTypes.h"
#include "Vector3f.h"
#include "TVector2.h"

namespace Toolbox
{	
	// Row based vector
	class Matrix33f
	{
	public:
		union
		{
			Float32 value[3][3];	
			Float32 array[3 * 3];
		};
		
	public:
		
		static const Matrix33f kIdentityMatrix;
		
		Matrix33f();
		Matrix33f(Float32 v11, Float32 v12, Float32 v13,
				  Float32 v21, Float32 v22, Float32 v23,
				  Float32 v31, Float32 v32, Float32 v33);
		
		Vector2f& row(Uint32 iIndex);
		const Vector2f& row(Uint32 iIndex) const;
		
		const Vector2f& translation() const;
		void setTranslation(const Vector2f& iTranslation);
		
		Matrix33f& operator*=(const Matrix33f& iOther);
		
		void createScale(const Vector2f& iScale);
		
		void translate(const Vector2f& iTranslation);
		void scale(const Vector2f& iScale);
		
		bool isAffine() const;
		bool isAffineNormalized() const;
		
		// oTranspose cannot be this
		void transpose(Matrix33f& oTranspose) const;
		
		Float32 linearDeterminant() const;
	
		void transformPoints(const Vector2f* iPoints, Uint32 iCount, Vector2f* oPoints, size_t iStrideIn = sizeof(Vector2f), size_t iStrideOut = sizeof(Vector2f)) const;
		void transformPoint(const Vector2f& iPoint, Vector2f& oPoint) const;
		
		void transform(const Vector3f& iVectorOrPoint, Vector3f& oVectorOrPoint) const;
		
		// Set this matrix to a characteristical transform
		void createTranslation(const Vector2f& iTranslation);
	};
	
	Matrix33f operator*(const Matrix33f& iM1, const Matrix33f& iM2);
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline Matrix33f::Matrix33f() {}
	
	inline Vector2f& Matrix33f::row(Uint32 iIndex)
	{
		TB_ASSERT(iIndex <= 2);
		return (Vector2f&) value[iIndex][0];
	}

	inline const Vector2f& Matrix33f::row(Uint32 iIndex) const
	{
		TB_ASSERT(iIndex <= 2);
		return (const Vector2f&) value[iIndex];
	}
	
	inline bool Matrix33f::isAffine() const
	{
		return (value[0][2]== 0.f) && (value[1][2]== 0.f);
	}

	inline bool Matrix33f::isAffineNormalized() const
	{
		return (value[0][2]== 0.f) && (value[1][2]== 0.f) && (value[2][2]== 1.f);
	}
	
	inline Matrix33f&
	Matrix33f::operator*=(const Matrix33f& iOther)
	{
		*this = *this * iOther;
		return *this;
	}
	
	inline const Vector2f&
	Matrix33f::translation() const
	{
		return row(2);
	}
}

#endif // _Matrix33f_H_