import 'package:robotlegs_di/robotlegs_di.dart';
import 'package:robotlegs_di/src/injection/injector.dart';
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

parentInjectorTestCase() {
  IInjector injector;
  IInjector childInjector;

  setUp(() {
    injector = new Injector();
    childInjector = injector.createChildInjector();

  });

  tearDown(() {
    injector = null;
    childInjector = null;
  });

  test('Create Child Injector', () {
    expect(childInjector.parentInjector, equals(injector));
  });

  test('Satisfies child injector', () {
    injector.map(InjectedClazz);

    bool satisfies = childInjector.satisfies(InjectedClazz);
    expect(satisfies, equals(true));
  });

  test('Satisfies directly child injector', () {
    injector.map(InjectedClazz);

    bool satisfies = childInjector.satisfiesDirectly(InjectedClazz);
    expect(satisfies, equals(false));
  });



  test('Set Parent Injector', () {
    childInjector = new Injector();
    childInjector.parentInjector = injector;
    expect(childInjector.parentInjector, equals(injector));
  });
}
