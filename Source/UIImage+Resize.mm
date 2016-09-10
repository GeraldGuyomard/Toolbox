/*
 *  Vector3.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#import "UIImage+Resize.h"
#include <algorithm>

using namespace Toolbox;

#pragma mark Resize
@implementation UIImage(Resize)

-(UIImage*) resizeWithScale:(Float32)iScale
{
	TB_ASSERT(iScale > 0.0f);
	
	CGSize size = self.size;
	size.width *= iScale;
	size.height *= iScale;
	
	return [self resize:size];
}

-(UIImage*) resize:(CGSize)iNewSize
{	
	//std::swap(iNewSize.width, iNewSize.height);
	
	CGImageRef img = self.CGImage;
	UIImage* resizedImage = nil;
	
	UIGraphicsBeginImageContext(iNewSize);
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		// Flip on Y
		CGContextTranslateCTM(context, 0, iNewSize.height);
		CGContextScaleCTM(context, 1, -1);
		
		CGContextTranslateCTM(context, iNewSize.width * 0.5f, iNewSize.height * 0.5f);
		CGContextRotateCTM(context, -M_PI / 2.f);
		CGContextTranslateCTM(context, -iNewSize.height * 0.5f, -iNewSize.width * 0.5f);

		// Coordinates are flipped (rotation 90°)
		CGRect r = CGRectMake(0, 0, iNewSize.height, iNewSize.width);
		CGContextDrawImage(context, r, img);
		
		resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	}
	
	UIGraphicsEndImageContext();
	
	return resizedImage;
}

#pragma mark ImageRGBA8
-(void) imageRGBA8:(Toolbox::P_ImageRGBA8&)oImage
{
	oImage = new ImageRGBA8;
	
	const Vector2i imageSize = self.size;
	oImage->create(imageSize);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(oImage->buffer(),
													   imageSize.x,
													   imageSize.y,
													   8 /*bits*/,
													   imageSize.x * sizeof(ColorRGBA8) /*bytesPerRow*/,
													   colorSpace,
													   kCGImageAlphaPremultipliedLast);
	
	CGColorSpaceRelease(colorSpace);
	
	// Y is inverted
	/*CGContextTranslateCTM(bitmapContext, 0, imageSize.y);
	CGContextScaleCTM(bitmapContext, 1, -1);*/
	
	CGRect r = CGRectMake(0, 0, imageSize.x, imageSize.y);
	CGContextDrawImage(bitmapContext, r, self.CGImage);	
	CGContextRelease(bitmapContext);
}

#pragma mark DebugTools

-(void) dumpToTmpWithName:(NSString*)iName
{
	NSString* fullPathName = [NSString stringWithFormat:@"%@%@.png", NSTemporaryDirectory(), iName];
	NSLogDebug(@"Dumping image to:%@", fullPathName);
	
	NSData* data = UIImagePNGRepresentation(self);
	[data writeToFile:fullPathName atomically:YES];
}

@end

