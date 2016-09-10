/*
 *  TextureMap.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "TextureMap.h"
#include "GLTools.h"
#include "MathTools.h"
#include "ImageRGBA8.h"
#include <algorithm>
#include <UIKit/UIKit.h>

namespace Toolbox
{

TextureMap::TextureMap()
: _Size(0, 0), _ID(0)
{
}

TextureMap::~TextureMap()
{
	if (_ID != 0)
	{
		glDeleteTextures(1, &_ID);
	}
}

void TextureMap::setActive()
{
	glEnable(GL_TEXTURE_2D);							
	
	TB_ASSERT(_ID != 0);
	glBindTexture(GL_TEXTURE_2D, _ID);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	
	assertIfGLFailed();
}

void TextureMap::createFromResource(NSString* iResourceName, P_TextureMap& oTexture)
{
	NSString* path = [[NSBundle mainBundle] pathForResource:iResourceName ofType:nil];
	NSData* data = [[NSData alloc] initWithContentsOfFile:path];
	
	UIImage* img = [[UIImage alloc] initWithData:data];
	
	oTexture = new TextureMap;
	
	oTexture->create(img.size, img);
	
	[img release];
	[data release];
}
	
void TextureMap::create(const Vector2i& iMaxSize, UIImage* iImage)
{
	if (_ID == 0)
	{
		// Create the GL Texture if not already
		glGenTextures(1, &_ID);
		TB_ASSERT(_ID);
		assertIfGLFailed();
	}
	
	// Prepare upload on GPU
	glBindTexture(GL_TEXTURE_2D, _ID);
	assertIfGLFailed();
	
	// Use filter
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	assertIfGLFailed();
	
	//CGSize imageSize = iImage.size;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(iImage.CGImage), CGImageGetHeight(iImage.CGImage));

	// Make sure that size are power of 2
	_Size.x = nearestButLowestPowerOf2(imageSize.width);
	_Size.x = std::min(_Size.x, iMaxSize.x);
	
	_Size.y = nearestButLowestPowerOf2(imageSize.height);
	_Size.y = std::min(_Size.y, iMaxSize.y);
	
	// Upload the bitmap
	const size_t bufferSize = _Size.x * _Size.y * sizeof(Uint32);
	Uint32* buffer = (Uint32*) malloc(bufferSize);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(buffer,
													   _Size.x,
													   _Size.y,
													   8 /*bits*/,
													   _Size.x * sizeof(Uint32) /*bytesPerRow*/,
													   colorSpace,
													   kCGImageAlphaPremultipliedLast);
	
	CGColorSpaceRelease(colorSpace);
	
	// Y is inverted
	CGContextTranslateCTM(bitmapContext, 0, _Size.y);
	CGContextScaleCTM(bitmapContext, 1, -1);
	
	CGRect r = CGRectMake(0, 0, _Size.x, _Size.y);
	CGContextDrawImage(bitmapContext, r, iImage.CGImage);	

	
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _Size.x, _Size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	assertIfGLFailed();
	
	free(buffer);
	CGContextRelease(bitmapContext);
}
	
void TextureMap::create(ImageRGBA8* iImage)
{
	if (_ID == 0)
	{
		// Create the GL Texture if not already
		glGenTextures(1, &_ID);
		TB_ASSERT(_ID);
		assertIfGLFailed();
	}
	
	// Prepare upload on GPU
	glBindTexture(GL_TEXTURE_2D, _ID);
	assertIfGLFailed();
	
	// Use filter
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	assertIfGLFailed();
		
	_Size = iImage->size();

	// Upload the bitmap
	
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _Size.x, _Size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, iImage->buffer());
	assertIfGLFailed();
}
	
} // End of toolbox