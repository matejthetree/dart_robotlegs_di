import 'package:robotlegs_di/robotlegs_di.dart';
import 'package:robotlegs_di/src/errors/injector_error.dart';
import 'package:robotlegs_di/src/injection/injector.dart';
import 'package:robotlegs_di/src/mapping/mapping.dart';
import 'package:test/test.dart';

import '../objects/objects.dart';

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

mappingTestCase() {
  IInjector injector;

  setUp(() {
    injector = new Injector();
  });

  tearDown(() {
    injector.teardown();
    injector = null;
  });

  test('Basic mapping', () {
    injector.map(InjectedClazz);

    InjectedClazz injectedClazz = injector.getInstance(InjectedClazz);
    expect(injectedClazz, isNotNull);
  });

  test('Satisfies', () {
    injector.map(InjectedClazz);

    bool satisfies = injector.satisfies(InjectedClazz);
    expect(satisfies, equals(true));
  });

  test('Satisfies directly', () {
    injector.map(InjectedClazz);

    bool satisfies = injector.satisfiesDirectly(InjectedClazz);
    expect(satisfies, equals(true));
  });

  test('Get mapping', () {
    injector.map(InjectedClazz);

    InjectionMapping injectionMapping = injector.getMapping(InjectedClazz);
    expect(injectionMapping, isNotNull);
  });

  test('Inject Into', () {
    injector.map(ValueHolder).toValue(new ValueHolder("injected"));

    ValueHolderInjectee instance = new ValueHolderInjectee();
    injector.injectInto(instance);

    expect(instance.valueHolder.value, equals("injected"));
  });

  test('Get or create new instance', () {
    injector.map(InjectedClazz).asSingleton();

    InjectedClazz instance = injector.getOrCreateNewInstance(InjectedClazz);
    InjectedClazz instance2 = injector.getOrCreateNewInstance(InjectedClazz);
    injector.unmap(InjectedClazz);
    InjectedClazz instance3 = injector.getOrCreateNewInstance(InjectedClazz);

    expect(identical(instance, instance2), isTrue);
    expect(identical(instance, instance3), isFalse);
  });

  test('Basic named mapping', () {
    injector.map(InjectedClazz, "named");

    InjectedClazz injectedClazzNamed =
        injector.getInstance(InjectedClazz, "named");
    expect(injectedClazzNamed, isNotNull);
    expect(() => injector.getInstance(InjectedClazz),
        throwsA(new isInstanceOf<InjectorMissingMappingError>()));
  });

  test('Mapping To Value', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    ValueHolder valueHolder = injector.getInstance(ValueHolder);
    expect(valueHolder.value, equals("abcABC-123"));
  });

  test('Mapping As Singleton', () {
    injector.map(InjectedClazz).asSingleton();
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(Clazz);

    Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz.myInjectedClazz, isNotNull);
    expect(myClazz.firstMethodWithParametersValue, isNotNull);
    expect(
        identical(
            myClazz.firstMethodWithParametersValue, myClazz.myInjectedClazz),
        isTrue);
  });
}
