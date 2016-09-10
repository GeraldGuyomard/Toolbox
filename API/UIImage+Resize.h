/*
 *  UIImage+Resize.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#include "ImageRGBA8.h"

@interface UIImage(Resize)
-(UIImage*) resize:(CGSize)iNewSize;
-(UIImage*) resizeWithScale:(Float32)iScale;
@end

@interface UIImage(ImageRGBA8)
-(void) imageRGBA8:(Toolbox::P_ImageRGBA8&)oImage;
@end

@interface UIImage(DebugTools)
-(void) dumpToTmpWithName:(NSString*)iName;
@end