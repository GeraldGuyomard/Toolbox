/*
 *  TextureMap.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_TextureMap_H_)
#define _TextureMap_H_

#include <OpenGLES/ES1/gl.h>
#include <UIKit/UIImage.h>
#include "RetainedObject.h"
#include "TVector2.h"

namespace Toolbox
{
	class ImageRGBA8;
	
	class TextureMap;
	typedef TSmartPtr<TextureMap> P_TextureMap;
	
	class TextureMap : public RetainedObject<TextureMap>
	{
	public:
		static void createFromResource(NSString* iResourceName, P_TextureMap& oTexture);
		
		TextureMap();
		~TextureMap();
		
		void create(const Vector2i& iMaxSize, UIImage* iImage);
		
		// Image must be power of two
		void create(ImageRGBA8* iImage);
		
		const Vector2i& size() const;
		
		void setActive();
		
	protected:
		Vector2i	_Size;
		GLuint		_ID;
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	
	inline const Vector2i& TextureMap::size() const
	{
		return _Size;
	}
	
} // end of namespace Toolbox

#endif // _TextureMap_H_