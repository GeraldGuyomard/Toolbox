/*
 *  World3D.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_World3D_H_)
#define _World3D_H_

#include "Node3D.h"
#include "SerializableObject.h"
#include "TVector2.h"

namespace Toolbox
{
	struct ConstraintData;
	class Camera3D;
	
	class World3D;
	typedef TSmartPtr<World3D> P_World3D;
	
	class World3D : public SerializableObject
	{
	public:
		TB_DECLARE_SERIALIZABLE_OBJECT(World3D, SerializableObject);
		
		World3D();
		
		Node3D* root() const;
		
		void render(Camera3D& iCamera, const Vector2f& iViewportSize, RenderOptions& ioOptions);
		
	protected:
		virtual void _encode(NSCoder* aCoder);
		virtual void _decode(NSCoder* aDecoder);
		
	protected:
		P_Node3D _Root;
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline Node3D*
	World3D::root() const
	{
		return _Root;
	}
}

#endif // _World3D_H_