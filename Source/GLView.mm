//
//  GLView.mm
//  Toolbox
//
//  Created by Gérald Guyomard on 29/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/glext.h>
#import "GLTools.h"
#import "GLManager.h"
#import "Camera3D.h"

using namespace Toolbox;

@interface GLView()

-(BOOL) createGLBuffers;
-(void) destroyGLBuffers;

@end

@implementation GLView

@synthesize delegate=_Delegate;

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

-(BOOL) setupGL
{
	self.autoresizesSubviews = YES;
	
	// Allow multi touch
	self.multipleTouchEnabled = YES;
	
	// Get the layer
	CAEAGLLayer* eaglLayer = (CAEAGLLayer*) self.layer;
	
	eaglLayer.opaque = YES;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
	
	
	EAGLContext* context = GLManager::instance().glContext();
	
	return (context != nil) && [EAGLContext setCurrentContext:context];	
}

-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
        if (![self setupGL])
		{
			[self release];
			return nil;
		}
    }
	
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
        if (![self setupGL])
		{
			[self release];
			return nil;
		}		
	}
	
	return self;
}

-(void) dealloc
{
    [super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	EAGLContext* context = GLManager::instance().glContext();
    [EAGLContext setCurrentContext:context];
	
    [self destroyGLBuffers];
    [self createGLBuffers];
    [self render];
}

-(BOOL) createGLBuffers
{
    TB_ASSERT(_FrameBufferID == 0);
    glGenFramebuffersOES(1, &_FrameBufferID);
	
	TB_ASSERT(_RenderBufferID == 0);
    glGenRenderbuffersOES(1, &_RenderBufferID);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _FrameBufferID);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _RenderBufferID);
	
	CAEAGLLayer* layer = (CAEAGLLayer*)self.layer;
	
	EAGLContext* context = GLManager::instance().glContext();
	TB_ASSERT(context != nil);
	
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _RenderBufferID);
    
	GLint width = 0;
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &width);
	_BackBufferSize.x = width;
	
	GLint height = 0;
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &height);
	_BackBufferSize.y = height;
    

	glGenRenderbuffersOES(1, &_DepthBufferID);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _DepthBufferID);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, width, height);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _DepthBufferID);

    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
        NSLog(@"could not create framebuffer %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


-(void) destroyGLBuffers
{
    
	if (_FrameBufferID != 0)
	{
		glDeleteFramebuffersOES(1, &_FrameBufferID);
		_FrameBufferID = 0;
	}
	
	if (_RenderBufferID != 0)
	{
		glDeleteRenderbuffersOES(1, &_RenderBufferID);
		_RenderBufferID = 0;
	}
    
    if(_DepthBufferID != 0)
	{
        glDeleteRenderbuffersOES(1, &_DepthBufferID);
        _DepthBufferID = 0;
    }
}

-(void) render
{
	EAGLContext* context = GLManager::instance().glContext();
	if (context != nil)
	{
		[EAGLContext setCurrentContext:context];
		assertIfGLFailed();
		
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _FrameBufferID);
		assertIfGLFailed();
		
		// Render
		if ([_Delegate respondsToSelector:@selector(render)])
		{
			[_Delegate render];
		}
		
		// PresentToScreen
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _RenderBufferID);
		[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	}	
}

-(void) startRendering
{
	if ((_RenderingTimer == nil) && (_RenderingInterval != 0))
	{
		_RenderingTimer = [NSTimer scheduledTimerWithTimeInterval:_RenderingInterval target:self selector:@selector(render) userInfo:nil repeats:YES];
	}
}


-(void) stopRendering
{
	[_RenderingTimer invalidate];
    _RenderingTimer = nil;
}

-(void) setRenderingInterval:(NSTimeInterval)interval
{
    _RenderingInterval = interval;
	[self stopRendering];
    [self startRendering];
}

-(Ray3D) ray:(UITouch*)iTouch
{
	CGPoint p = [iTouch locationInView:self];
	
	Ray3D ray;
	Camera3D* cam = [_Delegate respondsToSelector:@selector(camera)] ? [_Delegate camera] : NULL;
	if (NULL != cam)
	{
		cam->ray(p, ray); 	
	}
	else
	{
		ray = Ray3D::kNull;
	}
	
	return ray;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([_Delegate respondsToSelector:@selector(touchesBegan:withEvent:onGLView:)])
	{
		[_Delegate touchesBegan:touches withEvent:event onGLView:self];
	}
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([_Delegate respondsToSelector:@selector(touchesMoved:withEvent:onGLView:)])
	{
		[_Delegate touchesMoved:touches withEvent:event onGLView:self];
	}	
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([_Delegate respondsToSelector:@selector(touchesEnded:withEvent:onGLView:)])
	{
		[_Delegate touchesEnded:touches withEvent:event onGLView:self];
	}	
}

@end
