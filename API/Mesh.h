/*
 *  Mesh.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_Mesh_H_)
#define _Mesh_H_

#include "RetainedObject.h"
#include "Material.h"
#include <vector>
#include "Vertex.h"

namespace Toolbox
{
class Mesh;
typedef TSmartPtr<Mesh> P_Mesh;

class Mesh : public RetainedObject<Mesh>
{
public:
	Mesh();
	
	enum FFeatures
	{
		fUVs = 1 << 0,
		fNormals = 1 << 1
	};
	
	Uint32							features;
	P_Material 						material;
	std::vector<VertexPUVNormal>	vertices;
	std::vector<Uint16>				indices;
	
	std::vector<P_Mesh>				subMeshes;
	
	void render();
	
protected:
	void _selfRender();
};


// ********************************************************************************
// Inlined Implementations
// ********************************************************************************

	
} // end of namespace Toolbox

#endif // _Mesh_H_