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

class Reflector 
{
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Map<Type, TypeDescriptor> descriptorsCache = new Map<Type, TypeDescriptor>();
	
	List<ConstructorInjectionPoint> constructorInjectionPoints;
	
	List<PropertyInjectionPoint> propertyInjectionPoints; 
	
	List<MethodInjectionPoint> methodInjectionPoints; 
	
	List<PostConstructInjectionPoint> postConstructInjectionPoints; 
	
	List<PreDestroyInjectionPoint> preDestroyInjectionPoints; 
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	Reflector();
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	TypeDescriptor getDescriptor(Type type) 
	{
     if (descriptorsCache[type] == null)
    	 descriptorsCache[type] = createDescriptor(type);

     return descriptorsCache[type];
  }
	
	void addDescriptor(Type type, TypeDescriptor descriptor)
	{
		descriptorsCache[type] = descriptor;
	}
	
	Type getType(dynamic value)
	{
		return reflect(value).reflectee.runtimeType;
	}
	
	TypeDescriptor createDescriptor(Type type) 
	{
		constructorInjectionPoints = new List<ConstructorInjectionPoint>();
		propertyInjectionPoints = new List<PropertyInjectionPoint>();
		methodInjectionPoints = new List<MethodInjectionPoint>();
		postConstructInjectionPoints = new List<PostConstructInjectionPoint>();
		preDestroyInjectionPoints = new List<PreDestroyInjectionPoint>();
		
		final TypeDescriptor typeDescriptor = new TypeDescriptor(false);
		
		generateInjectionPoints(type);
		
		constructorInjectionPoints.forEach( (ConstructorInjectionPoint injectionPoint) => typeDescriptor.addConstructorInjectionPoint(injectionPoint));
		propertyInjectionPoints.forEach( (PropertyInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		methodInjectionPoints.forEach( (MethodInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		postConstructInjectionPoints.sort( (x, y) => x.order.compareTo(y.order) );
		postConstructInjectionPoints.forEach( (PostConstructInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		preDestroyInjectionPoints.sort( (x, y) => x.order.compareTo(y.order) );
		preDestroyInjectionPoints.forEach( (PreDestroyInjectionPoint injectionPoint) => typeDescriptor.addPreDestroyInjectionPoint(injectionPoint) );
		
		constructorInjectionPoints = propertyInjectionPoints = methodInjectionPoints = postConstructInjectionPoints = preDestroyInjectionPoints = null;
		
		return typeDescriptor;
	}
	
	void generateInjectionPoints(Type type) 
	{
		ClassMirror mirror = reflectClass(type);
		
		List<DeclarationMirror> constructors = new List.from(
      mirror.declarations.values.where( (declare) => declare is MethodMirror && declare.isConstructor)
    );
		
		constructors.forEach( (constructor) 
		{
      if (constructor is MethodMirror) 
      {
        _createConstructorInjectionPoint(constructor.constructorName, constructor.parameters);
      }
    });
		
		mirror.declarations.values.forEach( (DeclarationMirror declaration) 
		{
			declaration.metadata.forEach( (InstanceMirror metadata) 
			{
				if (metadata.reflectee is Inject)
				{
					if (declaration is VariableMirror) 
					{
						final String mappingId = Injector._getMappingId(declaration.type.reflectedType, (metadata.reflectee as Inject).name );
						
						_createPropertyInjectionPoint(mappingId, declaration.simpleName, (metadata.reflectee as Inject).optional);
					}
					else if (declaration is MethodMirror && !declaration.isGetter)
					{
						String name = declaration.simpleName.toString().split('=').first;  
						_createMethodInjectionPoint(new Symbol(name), declaration.parameters, (metadata.reflectee as Inject).optional);
					}
				} 
				else if (metadata.reflectee is PostConstruct) 
				{
					_createPostConstructInjectionPoint(declaration.simpleName, [], null, (metadata.reflectee as PostConstruct).order);
				}
				else if (metadata.reflectee is PreDestroy) 
				{
					_createPreDestroyInjectionPoint(declaration.simpleName, [], null, (metadata.reflectee as PreDestroy).order);
				}
			});
		});
	}
	
  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------
	
	void _createConstructorInjectionPoint(Symbol method, List<ParameterMirror> parameters)
	{
		ConstructorInjectionPoint injectionPoint;
		
		if (parameters == null || parameters.length == 0)
			injectionPoint = new NoParamsConstructorInjectionPoint(method);
		else
			injectionPoint = new ConstructorInjectionPoint(
					method,
					_getPositionalParameters(parameters), 
					_getNumberOfRequiredPositionalParameters(parameters),
					_getNamedParameters(parameters));
		
		constructorInjectionPoints.add(injectionPoint);
		
	}
	
	void _createPropertyInjectionPoint(String mappingId, Symbol property, bool optional) 
	{
		PropertyInjectionPoint injectionPoint = new PropertyInjectionPoint(mappingId, property, optional);
		
		propertyInjectionPoints.add(injectionPoint);
  }
	
	void _createMethodInjectionPoint(Symbol method, List<ParameterMirror> parameters, bool optional)
	{
		MethodInjectionPoint injectionPoint = new MethodInjectionPoint(
			method, 
			_getPositionalParameters(parameters), 
			_getNumberOfRequiredPositionalParameters(parameters),
			_getNamedParameters(parameters),
			optional);
		
		methodInjectionPoints.add(injectionPoint);
	}

	void _createPostConstructInjectionPoint(Symbol method, List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments, int order)
	{
		PostConstructInjectionPoint injectionPoint = new PostConstructInjectionPoint(method, positionalArguments, 0, namedArguments, order);
		
		postConstructInjectionPoints.add(injectionPoint);
	}

	void _createPreDestroyInjectionPoint(Symbol method, List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments, int order)
	{
		PreDestroyInjectionPoint injectionPoint = new PreDestroyInjectionPoint(method, positionalArguments, 0, namedArguments, order);
		
		preDestroyInjectionPoints.add(injectionPoint);
	}
	
	List<Type> _getPositionalParameters(List<ParameterMirror> parameterMirrors)
	{
		List<Type> parameters = new List<Type>();
		
		parameterMirrors.where((ParameterMirror parameter) => !parameter.isNamed).forEach(
			(ParameterMirror parameter) 
			{
				parameters.add(parameter.type.reflectedType);
			}
		); 
		
		return parameters;
	}

	int _getNumberOfRequiredPositionalParameters(List<ParameterMirror> parameterMirrors)
	{
		return parameterMirrors.where((ParameterMirror parameter) => !parameter.isNamed && !parameter.isOptional).length;
	}
	
	Map<Symbol, Type> _getNamedParameters(List<ParameterMirror> parameterMirrors)
	{
		Map<Symbol, Type> parameters = new Map<dynamic, Type>();
		
		parameterMirrors.where((ParameterMirror parameter) => !parameter.isNamed).forEach(
			(ParameterMirror parameter) 
			{
				parameters[parameter.simpleName] = parameter.type.reflectedType;
			}
		); 
		
    return parameters;
	}
}