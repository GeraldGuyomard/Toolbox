/*
 *  vectorEx.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_vectorEx_H_)
#define _vectorEx_H_

#include "BasicTypes.h"
#include <vector>

namespace Toolbox
{
	
	template <typename _Tp> typename std::vector<_Tp>::iterator find(std::vector<_Tp>& iVector, const _Tp& iElement);
	
	
	
	
	template <typename _Tp> typename std::vector<_Tp>::const_iterator find(const std::vector<_Tp>& iVector, const _Tp& iElement);
	
	template <typename _Tp> bool exists(const std::vector<_Tp>& iVector, const _Tp& iElt);
	
	template <typename _Tp> bool removeElement(std::vector<_Tp>& ioVector, const _Tp& iElement);
	
	// Inline implementation

	template <typename _Tp> inline typename std::vector<_Tp>::iterator find(std::vector<_Tp>& iVector, const _Tp& iElement)
	{
		const typename std::vector<_Tp>::iterator end = iVector.end();
		
		for (typename std::vector<_Tp>::iterator it = iVector.begin(); it != end; ++it)
		{
			const _Tp& elt = *it;
			if (elt == iElement)
			{
				return it;
			}
		}
		
		return iVector.end();
	}
	
	template <typename _Tp> typename std::vector<_Tp>::const_iterator find(const std::vector<_Tp>& iVector, const _Tp& iElement)	
	{
		const typename std::vector<_Tp>::const_iterator end = iVector.end();
		
		for (typename std::vector<_Tp>::const_iterator it = iVector.begin(); it != end; ++it)
		{
			const _Tp& elt = *it;
			if (elt == iElement)
			{
				return it;
			}
		}
		
		return iVector.end();
	}
	
	template <typename _Tp> inline bool exists(const std::vector<_Tp>& iVector, const _Tp& iElt)
	{
		return find(iVector, iElt) != iVector.end();
	}
	
	template <typename _Tp> bool removeElement(std::vector<_Tp>& ioVector, const _Tp& iElement)
	{
		const typename std::vector<_Tp>::iterator end = ioVector.end();
		
		for (typename std::vector<_Tp>::iterator it = ioVector.begin(); it != end; ++it)
		{
			const _Tp& elt = *it;
			if (elt == iElement)
			{
				ioVector.erase(it);
				return true;
			}
		}
		
		return false;
	}

} // End of namespace Toolbox

#endif // _vectorEx_H_