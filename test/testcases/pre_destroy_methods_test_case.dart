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

preDestroyMethodsTestCase() {
  IInjector injector;
  Clazz myClazz;

  setUp(() {
    injector = new Injector();
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(InjectedClazz);
    injector.map(Clazz);

    myClazz = injector.getInstance(Clazz);
  });

  tearDown(() {
    injector = null;
  });

  test('Running Methods', () {
    injector.teardown();

    expect(myClazz.hasRunFirstPreDestroyMethod, isTrue);
    expect(myClazz.hasRunSecondPreDestroyMethod, isTrue);
    expect(myClazz.hasRunLastPreDestroyMethod, isTrue);
  });

  test('Running Methods in Right Order', () {
    injector.teardown();

    expect(myClazz.hasRunFirstPreDestroyMethod, isTrue);
    expect(myClazz.hasRunSecondPreDestroyMethod, isTrue);
    expect(myClazz.hasRunLastPreDestroyMethod, isTrue);

    expect(
        myClazz.firstPreDestroytMethodOrder <
            myClazz.secondPreDestroytMethodOrder,
        isTrue);
    expect(
        myClazz.secondPreDestroytMethodOrder <
            myClazz.lastPreDestroytMethodOrder,
        isTrue);
  });
}
