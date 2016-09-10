/*
 *  ImageRGBA8.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_ImageRGBA8_H_)
#define _ImageRGBA8_H_

#include "RetainedObject.h"
#include "TVector2.h"
#include "Color.h"
#import <UIKit/UIKit.h>

namespace Toolbox
{
	class ImageRGBA8;
	typedef TSmartPtr<ImageRGBA8> P_ImageRGBA8;
	
	class ImageRGBA8 : public RetainedObject<ImageRGBA8>
	{
	public:
		ImageRGBA8();
		~ImageRGBA8();
		
		void create(const Vector2i& iSize);
		
		UIImage* createUIImage();
		
		const Vector2i& size() const;
		ColorRGBA8* buffer();
		ColorRGBA8& pixelAt(const Vector2i& iCoordinates);
		ColorRGBA8* pixelAtOrNULL(const Vector2i& iCoordinates);
		
		ColorRGBA8 pixelOrClearColorAt(const Vector2i& iCoordinates) const;
		
		void freeBuffer();
		void clear();
		void fill(const ColorRGBA8& iColor);
		
		// Debug
		void dumpToTmp(NSString* iName);
		
	protected:
		Vector2i	_Size;
		ColorRGBA8*	_Buffer;
		
	private:
		static void _releaseImage(void *info, const void *data, size_t size);
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline const Vector2i& ImageRGBA8::size() const
	{
		return _Size;
	}
	
	inline ColorRGBA8* ImageRGBA8::buffer()
	{
		return _Buffer;
	}
	
	inline void ImageRGBA8::clear()
	{
		fill(ColorRGBA8::kClearColor);
	}
	
	inline ColorRGBA8& ImageRGBA8::pixelAt(const Vector2i& iCoordinates)
	{
		TB_ASSERT(iCoordinates.x >= 0);
		TB_ASSERT(iCoordinates.y >= 0);
		TB_ASSERT(iCoordinates.x < _Size.x);
		TB_ASSERT(iCoordinates.y < _Size.y);
		
		return *(_Buffer + (iCoordinates.y * _Size.x) + iCoordinates.x);
	}
	
} // end of namespace Toolbox

#endif // _ImageARGB32_H_