/*
* Copyright (c) 2014 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

part of robotlegs_di;

class SingletonProvider implements IProvider
{
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	IInjector _creatingInjector;
	Type _responseType ;
	dynamic _response;
	bool _destroyed;

	//-----------------------------------
	//
	// Constructor
	//
	//-----------------------------------
	
	SingletonProvider(this._creatingInjector, this._responseType );

	//-----------------------------------
	//
	// Public Methods
	//
	//-----------------------------------
  
	dynamic apply(IInjector injector, Type type, Map injectParameters) 
	{
		if (_response == null)
			_response = reflectClass(type).newInstance(const Symbol(''), []).reflectee;
		
  	return _response;
  }
  
  void destroy() 
  {
  	_destroyed = true;
  	if (_response == null)
  		return;
  	
  	TypeDescriptor descriptor = _creatingInjector.getTypeDescriptor(_responseType);
  	PreDestroyInjectionPoint preDestroyInjectonPoint = descriptor.preDestroyMethods;
  	while (preDestroyInjectonPoint != null)
  	{
  		preDestroyInjectonPoint.applyInjection(_creatingInjector, _response, _responseType);
  		preDestroyInjectonPoint = preDestroyInjectonPoint.next;
  	}
  	_response = null;
  }
}