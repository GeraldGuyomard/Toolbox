/*
 *  GLManager.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_GLManager_H_)
#define _GLManager_H_

#include <OpenGLES/ES1/gl.h>
#import <OpenGLES/EAGLDrawable.h>

namespace Toolbox
{
	class GLManager
	{
	public:
		static GLManager& instance();
		
		EAGLContext* glContext();
		
		void destroyGLContext();
		
	private:
		GLManager();
		~GLManager();
		
		static GLManager s_Instance;
		
		EAGLContext* _GLContext;
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline GLManager&
	GLManager::instance()
	{
		return s_Instance;
	}

}

#endif // _GLManager_H_