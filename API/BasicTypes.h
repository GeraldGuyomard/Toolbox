/*
 *  BasicTypes.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_BasicTypes_H_)
#define _BasicTypes_H_

#include <assert.h>

namespace Toolbox
{
	typedef char Int8;
	typedef unsigned char Uint8;

	typedef short Int16;
	typedef unsigned short Uint16;
	
	typedef int Int32;
	typedef unsigned int Uint32;
	
	typedef float Float32;
	typedef double Float64;
	
	typedef unsigned char Bool8;
	typedef unsigned int Bool32;
}

// Useful macros
#if DEBUG
	#define TB_ASSERT(cond) assert(cond)
	#define NSLogDebug(f, ...) { NSLog(f, __VA_ARGS__); }
#else
	#define TB_ASSERT(cond) {}
	#define NSLogDebug(f, ...) {}
#endif

#endif // _BasicTypes_H_