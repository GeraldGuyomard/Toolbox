/*
 *  ImageRGBA8.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "ImageRGBA8.h"
#include "Color.h"
#import "UIImage+Resize.h"

namespace Toolbox
{

ImageRGBA8::ImageRGBA8()
: _Buffer(NULL), _Size(0, 0)
{}
	
ImageRGBA8::~ImageRGBA8()
{
	freeBuffer();
}
	
void ImageRGBA8::create(const Vector2i& iSize)
{
	freeBuffer();
	
	_Size = iSize;
	if ((iSize.x != 0) && (iSize.y != 0))
	{
		_Buffer = new ColorRGBA8[iSize.x * iSize.y];
	}
}
	
void ImageRGBA8::freeBuffer()
{
	if (NULL != _Buffer)
	{
		delete[] _Buffer;
		_Buffer = NULL;
	}
}

void ImageRGBA8::fill(const ColorRGBA8& iColor)
{
	TB_ASSERT(NULL != _Buffer);	
	ColorRGBA8* p = _Buffer;
	ColorRGBA8* const end = _Buffer + (_Size.x * _Size.y);
	
	for (;p < end; ++p)
	{
		*p = iColor;
	}
}

ColorRGBA8 ImageRGBA8::pixelOrClearColorAt(const Vector2i& iCoordinates) const
{
	if ((iCoordinates.x >= 0) && (iCoordinates.y >= 0) && (iCoordinates.x < _Size.x) && (iCoordinates.y < _Size.y))
	{
		return *(_Buffer + (iCoordinates.y * _Size.x) + iCoordinates.x);	
	}
	else
	{
		return ColorRGBA8::kClearColor;
	}
}
	
ColorRGBA8* ImageRGBA8::pixelAtOrNULL(const Vector2i& iCoordinates)
{
	if ((iCoordinates.x >= 0) && (iCoordinates.y >= 0) && (iCoordinates.x < _Size.x) && (iCoordinates.y < _Size.y))
	{
		return _Buffer + (iCoordinates.y * _Size.x) + iCoordinates.x;	
	}
	else
	{
		return NULL;
	}
}
	
void ImageRGBA8::_releaseImage(void *info, const void *data, size_t size)
{
	ImageRGBA8* img = (ImageRGBA8*) info;
	img->release();
}
	
UIImage* ImageRGBA8::createUIImage()
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	this->retain(); // To be released by _releaseImage
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(this,
																  _Buffer, sizeof(ColorRGBA8) * _Size.x * _Size.y,
																  &ImageRGBA8::_releaseImage);
	
	CGImageRef cgImage = CGImageCreate(_Size.x, _Size.y,
									   8 /*bits per component*/,
									   sizeof(ColorRGBA8) * 8/*bit per pixel*/,
									   _Size.x * sizeof(ColorRGBA8),
									   colorSpace,
									   kCGImageAlphaPremultipliedLast,
									   dataProvider,
									   NULL /*decode*/,
									   true /*should interpolate*/,
									   kCGRenderingIntentDefault);
	CGColorSpaceRelease(colorSpace);
	CGDataProviderRelease(dataProvider);
	
	UIImage* img = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	return img;
}
	
void ImageRGBA8::dumpToTmp(NSString* iName)
{
	UIImage* img = createUIImage();
	[img dumpToTmpWithName:iName];
}
	
} // End of toolbox