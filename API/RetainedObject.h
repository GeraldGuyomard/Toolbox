/*
 *  RetainedObject.h
 *  Toolbox
 *
 *  Created by Gérald Guyomard on 19/09/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(_RetainedObject_H_)
#define _RetainedObject_H_

#include "BasicTypes.h"

namespace Toolbox
{
	class RetainedObjectPrivate
	{
	public:
		RetainedObjectPrivate();
		
		void retain();
		
	protected:
		Int32 _RetainCount;
	};
	
	// The base class
	template <class TSubclass> class RetainedObject : public RetainedObjectPrivate
	{
	public:
		RetainedObject();
		bool release();
	};
	
	// The smart ptr
	template <class TRetainedObject> class TSmartPtr
	{
	public:
		TSmartPtr();
		TSmartPtr(const TSmartPtr& iOtherPtr);
		TSmartPtr(TRetainedObject* iObject);
		TSmartPtr(TRetainedObject& iObject);
		
		~TSmartPtr();
		
		TRetainedObject* operator->() const;
		TRetainedObject& operator*() const;
		
		operator TRetainedObject*() const;
		operator TRetainedObject&() const;
		
		TRetainedObject* object() const;
		
		TSmartPtr<TRetainedObject>& operator=(TRetainedObject* iObject);
		TSmartPtr<TRetainedObject>& operator=(TRetainedObject& iObject);
		TSmartPtr<TRetainedObject>& operator=(const TRetainedObject& iObject);
		TSmartPtr<TRetainedObject>& operator=(const TSmartPtr<TRetainedObject>& iOther);
		
		bool operator==(const TSmartPtr& iObject) const;
		bool operator!=(const TSmartPtr& iObject) const;
		
		bool operator==(TRetainedObject* iObject) const;
		bool operator!=(TRetainedObject* iObject) const;
		
	private:
		void _retain(TRetainedObject* iObject);
		void _release();
		
		TRetainedObject* _Object;
	};
	
	// ********************************************************************************
	// Inlined Implementations
	// ********************************************************************************
	inline RetainedObjectPrivate::RetainedObjectPrivate()
	: _RetainCount(0)
	{}
	
	inline void RetainedObjectPrivate::retain()
	{
		++_RetainCount;
	}
	
	template <class TSubclass> inline RetainedObject<TSubclass>::RetainedObject()
	: RetainedObjectPrivate()
	{}
	
	template <class TSubclass> inline bool RetainedObject<TSubclass>::release()
	{
		if (--_RetainCount == 0)
		{
			delete (TSubclass*) this;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	// TSmartPtr
	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>::TSmartPtr()
	: _Object(NULL)
	{}
	
	template <class TRetainedObject> inline void TSmartPtr<TRetainedObject>::_retain(TRetainedObject* iObject)
	{
        _Object = iObject;
		if (_Object != NULL)
		{
			_Object->retain();
		}
	}
	
	template <class TRetainedObject> inline void TSmartPtr<TRetainedObject>::_release()
	{
		if (_Object != NULL)
		{
			_Object->release();
		}
	}
	
	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>::TSmartPtr(const TSmartPtr& iOtherPtr)
	{
		_retain(iOtherPtr._Object);
	}
	
	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>::TSmartPtr(TRetainedObject* iObject)
	{
		_retain(iObject);
	}

	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>::TSmartPtr(TRetainedObject& iObject)
	{
		TB_ASSERT(NULL != &iObject);
		_retain(&iObject);
	}
	
	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>::~TSmartPtr()
	{
		_release();
	}
	
	template <class TRetainedObject> inline TRetainedObject* TSmartPtr<TRetainedObject>::operator->() const
	{
		TB_ASSERT(_Object != NULL);
		return _Object;
	}
	
	template <class TRetainedObject> inline TRetainedObject& TSmartPtr<TRetainedObject>::operator*() const
	{
		TB_ASSERT(_Object != NULL);
		return *_Object;
	}
	
	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>::operator TRetainedObject*() const
	{
		return _Object;
	}
	
	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>::operator TRetainedObject&() const
	{
		TB_ASSERT(_Object != NULL);
		return *_Object;
	}
	
	template <class TRetainedObject> inline TRetainedObject* TSmartPtr<TRetainedObject>::object() const
	{
		return _Object;	
	}
	
	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>& TSmartPtr<TRetainedObject>::operator=(TRetainedObject* iObject)
	{
		if (iObject != _Object)
		{
			_release();
			_retain(iObject);
		}
		
		return *this;
	}

	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>& TSmartPtr<TRetainedObject>::operator=(TRetainedObject& iObject)
	{
		TRetainedObject* pObject = &iObject;
		TB_ASSERT(NULL != pObject);
		
		return *this = pObject;
	}

	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>& TSmartPtr<TRetainedObject>::operator=(const TRetainedObject& iObject)
	{
		TRetainedObject* pObject = (TRetainedObject*) &iObject;
		TB_ASSERT(NULL != pObject);
		
		return *this = pObject;
	}
	
	template <class TRetainedObject> inline TSmartPtr<TRetainedObject>& TSmartPtr<TRetainedObject>::operator=(const TSmartPtr<TRetainedObject>& iOther)
	{
		if (iOther._Object != _Object)
		{
			_release();
			_retain(iOther._Object);
		}
		
		return *this;
	}
	
	template <class TRetainedObject> inline bool TSmartPtr<TRetainedObject>::operator==(const TSmartPtr& iObject) const
	{
		return _Object == iObject._Object;
	}
	
	template <class TRetainedObject> bool TSmartPtr<TRetainedObject>::operator!=(const TSmartPtr& iObject) const
	{
		return _Object != iObject._Object;
	}
	
	template <class TRetainedObject> inline bool TSmartPtr<TRetainedObject>::operator==(TRetainedObject* iObject) const
	{
		return _Object == iObject;
	}
	
	template <class TRetainedObject> bool TSmartPtr<TRetainedObject>::operator!=(TRetainedObject* iObject) const
	{
		return _Object != iObject;
	}
}

#endif // _RetainedObject_H_