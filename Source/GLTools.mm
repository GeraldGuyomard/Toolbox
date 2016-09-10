/*
 *  GLTools.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "GLTools.h"
#include <OpenGLES/ES1/gl.h>

namespace Toolbox
{

#if !defined(NDEBUG)
	
void assertIfGLFailed()
{
	GLenum err = glGetError();
	if (err != GL_NO_ERROR)
	{
		printf("GL Failed:%x\n", err);
		TB_ASSERT(false);
	}
}
	
#endif
	
} // End of toolbox