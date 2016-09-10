/*
 *  Toolbox.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Toolbox_H_)
#define _Toolbox_H_

#include "BasicTypes.h"


namespace Toolbox
{
	class ToolboxSingleton
	{
	public:
		ToolboxSingleton();
		~ToolboxSingleton();
		
		static ToolboxSingleton& instance();
	};
}

#endif // _Toolbox_H_