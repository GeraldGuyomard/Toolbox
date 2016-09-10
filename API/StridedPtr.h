/*
 *  StridedArray.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_StridedArray_H_)
#define _StridedArray_H_

#include "BasicTypes.h"

namespace Toolbox
{
template <class TElement> class StridedPtr
{
public:
	StridedPtr(TElement* iFirstElement, size_t iStride);
	StridedPtr(const TElement* iFirstElement, size_t iStride);
	
	TElement& operator*();
	TElement& operator[](size_t iIndex);
	
	StridedPtr& operator++(); // ++v
	StridedPtr& operator++(int); // v++
	
private:
	TElement* 	_Object;
	size_t		_Stride;
};
	
// ********************************************************************************
// Inlined Implementations
// ********************************************************************************
template <class TElement> inline StridedPtr<TElement>::StridedPtr(TElement* iFirstElement, size_t iStride)
: _Object(iFirstElement), _Stride(iStride)
{}

template <class TElement> inline StridedPtr<TElement>::StridedPtr(const TElement* iFirstElement, size_t iStride)
: _Object((TElement*) iFirstElement), _Stride(iStride)
{}

template <class TElement> inline TElement& StridedPtr<TElement>::operator*()
{
	TB_ASSERT(NULL != _Object);
	return *_Object;
}
	
template <class TElement> inline TElement& StridedPtr<TElement>::operator[](size_t iIndex)
{
	return *(TElement*) ((Uint8*) _Object + (iIndex * _Stride));
}

template <class TElement> inline StridedPtr<TElement>& StridedPtr<TElement>::operator++()
{
	// ++v
	_Object = (TElement*) ((Uint8*) _Object + _Stride);
	return *this;
}
	
template <class TElement> inline StridedPtr<TElement>& StridedPtr<TElement>::operator++(int)
{
	// v++
	_Object = (TElement*) ((Uint8*) _Object + _Stride);
	return *this;
}
	
} // end of namespace Toolbox
#endif // _StridedArray_H_