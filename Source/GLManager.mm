/*
 *  GLManager.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "GLManager.h"

namespace Toolbox
{

GLManager GLManager::s_Instance;

GLManager::GLManager()
: _GLContext(0)
{}

GLManager::~GLManager()
{
	destroyGLContext();
}
	
EAGLContext*
GLManager::glContext()
{
	if (_GLContext == 0)
	{
		_GLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		TB_ASSERT(_GLContext != 0);
		const BOOL ok = [EAGLContext setCurrentContext:_GLContext];
		TB_ASSERT(ok);
		
	}
	
	return _GLContext;	
}

void
GLManager::destroyGLContext()
{
	if (_GLContext != 0)
	{
		if ([EAGLContext currentContext] == _GLContext)
		{
			[EAGLContext setCurrentContext:nil];
		}
		
		[_GLContext release];
		_GLContext = nil;
	}
}
	
} // End of toolbox