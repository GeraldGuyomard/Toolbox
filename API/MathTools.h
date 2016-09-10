/*
 *  MathTools.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_MathTools_H_)
#define _MathTools_H_

#include <math.h>

#define DEFAULT_EPSILON 1e-3f

namespace Toolbox
{
	enum EAxis
	{
		eX = 0,
		eY = 1,
		eZ = 2,
		
		eAxisCount
	};
	
	Float32 degreesInRadians(Float32 iAngleInDeg);
	Float32 radiansInDegrees(Float32 iAngleInRad);
	
	template <typename T> class TConstants
	{};
	
	template<> class TConstants<Float32>
	{
	public:
		static const Float32 kDefaultEpsilon; 	
	};
	
	template<> class TConstants<Int32>
	{
	public:
		enum
		{
			kDefaultEpsilon = 0	
		};
	};
	bool isNearZero(Float32 iValue, Float32 iEpsilon);
	template <typename TScalar> bool isNearValue(TScalar iValue1, TScalar iValue2, TScalar iEpsilon=TConstants<TScalar>::kDefaultEpsilon);

	Uint32 nearestButLowestPowerOf2(Uint32 iValue);
	
	Int32 roundToInt(Float32 iValue);
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline bool isNearZero(Float32 iValue, Float32 iEpsilon = DEFAULT_EPSILON)
	{
		return (iValue >=-iEpsilon) && (iValue <= iEpsilon);
	}

	template <typename TScalar> inline bool isNearValue(TScalar iValue1, TScalar iValue2, TScalar iEpsilon)
	{
		const TScalar delta = iValue1 - iValue2;
		return (delta >=-iEpsilon) && (delta <= iEpsilon);
	}
	
	inline Int32 roundToInt(Float32 iValue)
	{
		return Int32(iValue + 0.5f);
	}
	
	inline Float32 degreesInRadians(Float32 iAngleInDeg)
	{
		return iAngleInDeg * (Float32(M_PI) / 180.0f);	
	}

	inline Float32 radiansInDegrees(Float32 iAngleInRad)
	{
		return iAngleInRad * (180.0f / Float32(M_PI));	
	}
	
} // end of namespace Toolbox

#endif // _MathTools_H_