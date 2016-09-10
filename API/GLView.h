//
//  GLView.h
//  Toolbox
//
//  Created by Gérald Guyomard on 29/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <OpenGLES/ES1/gl.h>

#import "TVector2.h"
#import "Ray3D.h"

namespace Toolbox
{
	class Camera3D;
}

@protocol GLViewDelegate;

@interface GLView : UIView
{
@private
    
	Toolbox::Vector2i _BackBufferSize;
    
    GLuint _RenderBufferID;
	GLuint _FrameBufferID;
    GLuint _DepthBufferID;
	
	NSTimeInterval	_RenderingInterval;
	NSTimer*		_RenderingTimer;
	
	NSObject<GLViewDelegate>* _Delegate;
}

@property(assign) NSObject<GLViewDelegate>* delegate;

-(void) setRenderingInterval:(NSTimeInterval)interval;
-(void) startRendering;
-(void) stopRendering;

-(void) render;

-(Toolbox::Ray3D) ray:(UITouch*)iTouch;

@end

@protocol GLViewDelegate<NSObject>

@optional
-(void) render;

-(Toolbox::Camera3D*) camera;

// Input
-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event onGLView:(GLView*)iView;
-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event onGLView:(GLView*)iView;
-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event onGLView:(GLView*)iView;

@end

