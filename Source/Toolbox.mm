/*
 *  Toolbox.mm
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Toolbox.h"

#include "World3D.h"
#include "Node3D.h"
#include "Camera3D.h"
#include "Box3D.h"
#include "Quad3D.h"

namespace Toolbox
{

static ToolboxSingleton* s_Instance = NULL;
	
ToolboxSingleton::ToolboxSingleton()
{
	TB_ASSERT(NULL == s_Instance);	
	s_Instance = this;
	
	World3D::registerClass();
	Node3D::registerClass();
	Camera3D::registerClass();
	PerspectiveCamera3D::registerClass();
	OrthoCamera3D::registerClass();
	Quad3D::registerClass();
	Box3D::registerClass();
	
}
	
ToolboxSingleton::~ToolboxSingleton()
{
	TB_ASSERT(this == s_Instance);	
	s_Instance = 0;	
}
	
ToolboxSingleton&
ToolboxSingleton::instance()
{
	TB_ASSERT(NULL != s_Instance);
	return *s_Instance;	
}
	
} // End of toolbox