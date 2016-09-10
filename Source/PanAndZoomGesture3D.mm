//
//  PanAndZoomGesture3D.mm
//  Toolbox
//
//  Created by Gérald Guyomard on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PanAndZoomGesture3D.h"
#import "vectorEx.h"
#import "GLView.h"

@implementation PanAndZoomGesture3D

+(id) panAndZoomGestureWithGLView:(GLView*)iGLView
{
	return [[[PanAndZoomGesture3D alloc] initWithGLView:iGLView] autorelease];
}

-(Float32) zoomFactor
{
	if (_Cameras.size() == 0)
	{
		return 0.f;
	}
	
	return _Cameras.front()->zoomFactor();
}

-(Toolbox::Vector2f) panOffset
{
	if (_Cameras.size() == 0)
	{
		return Toolbox::Vector2f::kNull;
	}
	
	return _Cameras.front()->panOffset();		
}

-(void) addCamera:(Toolbox::Camera3D*)iCamera
{
	if (!Toolbox::exists<Toolbox::P_Camera3D>(_Cameras, iCamera))
	{
		_Cameras.push_back(iCamera);
	}
}

/*
-(void) touchesbegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesbegan:touches withEvent:event];
}
*/

-(void) pan:(const Toolbox::Vector2f&)iDirection
{
	Toolbox::Vector2f pan = [self panOffset];
	pan += iDirection;
	
	const std::vector<Toolbox::P_Camera3D>::iterator end = _Cameras.end();
	for (std::vector<Toolbox::P_Camera3D>::iterator it = _Cameras.begin(); it != end; ++it)
	{
		(*it)->setPanOffset(pan);
	}
}

-(void) zoom:(Float32)iZoom
{
	float z = [self zoomFactor];
	z *= iZoom;
	
	const std::vector<Toolbox::P_Camera3D>::iterator end = _Cameras.end();
	for (std::vector<Toolbox::P_Camera3D>::iterator it = _Cameras.begin(); it != end; ++it)
	{
		(*it)->setZoomFactor(z);
	}	
}

-(BOOL) touchesbegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	if ([touch tapCount] == 2)
	{
		// Zoom in or out
		Float32 z;
		if ([[event allTouches] count] > 1)
		{
			z = 0.5f;	
		}
		else
		{
			z = 2.f;		
		}
		
		[self zoom:z];
		
		return YES;
	}
	
	return NO;
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesMoved:touches withEvent:event];
		
	NSSet* allTouches = [event allTouches];
	if ([allTouches count] == 2)
	{
		Toolbox::Vector2f previous[2];
		Toolbox::Vector2f current[2];
		Toolbox::Vector2f dir[2];
		
		NSEnumerator* enumerator = [allTouches objectEnumerator];
		Toolbox::Uint32 i=0;
		while (UITouch* touch = [enumerator nextObject])
		{
			previous[i] = [touch previousLocationInView:_GLView];
			current[i] = [touch locationInView:_GLView];
			dir[i] = current[i] - previous[i];
			++i;
		}
		
		TB_ASSERT(i == 2);
		if ((dir[0] * dir[1]) < 0)
		{
			// Zoom
			float previousDist 	= (previous[1] - previous[0]).length();
			float dist			= (current[1] - current[0]).length();
			
			float r = dist /previousDist;
			
			[self zoom:r];
			
		}
		else
		{
			// Pan
			dir[0] /= [self zoomFactor];
			
			dir[0].y = -dir[0].y;
			[self pan:dir[0]];
		}
	}
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesEnded:touches withEvent:event];
}

@end
