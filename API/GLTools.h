/*
 *  GLTools.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_GLTools_H_)
#define _GLTools_H_

namespace Toolbox
{
#if defined(NDEBUG)
	
	inline void assertIfGLFailed() {}
	
#else
	void assertIfGLFailed();
#endif

} // end of namespace Toolbox

#endif // _GLTools_H_