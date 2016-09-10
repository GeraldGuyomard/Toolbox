/*
 *  Color.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Color_H_)
#define _Color_H_

#include "Vector3f.h"
#include "TVector2.h"
#include "Matrix44f.h"

namespace Toolbox
{

class ColorRGBAF;
	
class ColorRGBA8
{
public:
	ColorRGBA8();
	ColorRGBA8(Uint8 r, Uint8 g, Uint8 b, Uint8 a=255);
	ColorRGBA8(const ColorRGBAF& iColorF);
	
	void set(Uint8 r, Uint8 g, Uint8 b, Uint8 a=255);
	
	Uint8 red;
	Uint8 green;
	Uint8 blue;
	Uint8 alpha;
	
public:
	static const ColorRGBA8 kClearColor;
};

class ColorRGBAF
{
public:
	ColorRGBAF();
	ColorRGBAF(Float32 r, Float32 g, Float32 b, Float32 a=1.f);
	ColorRGBAF(const ColorRGBA8& iColor8);
	
	void set(Float32 r, Float32 g, Float32 b, Float32 a=1.f);
	
	Float32 red;
	Float32 green;
	Float32 blue;
	Float32 alpha;
};
	
// Inlined implementations
inline ColorRGBA8::ColorRGBA8()
{}
	
inline ColorRGBA8::ColorRGBA8(Uint8 r, Uint8 g, Uint8 b, Uint8 a)
{
	set(r, g, b, a);
}	

inline ColorRGBA8::ColorRGBA8(const ColorRGBAF& iColorF)
{	
	set(iColorF.red * 255.f, iColorF.green * 255.f, iColorF.blue * 255.f, iColorF.alpha * 255.f);
}
	
inline void ColorRGBA8::set(Uint8 r, Uint8 g, Uint8 b, Uint8 a)
{
	red = r;
	green = g;
	blue = b;
	alpha = a;
}

	inline ColorRGBAF::ColorRGBAF()
	{}
	
	inline ColorRGBAF::ColorRGBAF(Float32 r, Float32 g, Float32 b, Float32 a)
	{
		set(r, g, b, a);
	}	
	
	inline ColorRGBAF::ColorRGBAF(const ColorRGBA8& iColor8)
	{	
		const Float32 inv255 = 1.f / 255.f;
		set(Float32(iColor8.red) * inv255, Float32(iColor8.green) * inv255, Float32(iColor8.blue) * inv255, Float32(iColor8.alpha) * inv255);
	}
	
	inline void ColorRGBAF::set(Float32 r, Float32 g, Float32 b, Float32 a)
	{
		red = r;
		green = g;
		blue = b;
		alpha = a;
	}
	
}

#endif // _Color_H_