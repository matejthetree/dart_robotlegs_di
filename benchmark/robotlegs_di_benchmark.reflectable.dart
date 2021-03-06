// This file has been generated by the reflectable package.
// https://github.com/dart-lang/reflectable.

import "dart:core";
import 'benchmarks/mapping_benchmark.dart' as prefix1;
import 'package:robotlegs_di/src/reflection/reflector.dart' as prefix0;

// ignore:unused_import
import "package:reflectable/mirrors.dart" as m;
// ignore:unused_import
import "package:reflectable/src/reflectable_transformer_based.dart" as r;
// ignore:unused_import
import "package:reflectable/reflectable.dart" show isTransformed;

final _data = {
  const prefix0.Reflect(): new r.ReflectorData(
      <m.TypeMirror>[
        new r.NonGenericClassMirrorImpl(
            r"Abstract",
            r".Abstract",
            519,
            0,
            const prefix0.Reflect(),
            const <int>[0],
            const <int>[1, 2, 3, 4, 5],
            const <int>[],
            1,
            {},
            {},
            {},
            0,
            0,
            const <int>[],
            const <Object>[const prefix0.Reflect()],
            null),
        new r.NonGenericClassMirrorImpl(
            r"Object",
            r"dart.core.Object",
            7,
            1,
            const prefix0.Reflect(),
            const <int>[1, 2, 3, 4, 5, 6],
            const <int>[1, 2, 3, 4, 5],
            const <int>[],
            null,
            {},
            {},
            {r"": (b) => () => b ? new Object() : null},
            1,
            1,
            const <int>[],
            const <Object>[],
            null)
      ],
      <m.DeclarationMirror>[
        new r.MethodMirrorImpl(r"", 64, 0, -1, -1, -1, const <int>[],
            const prefix0.Reflect(), const []),
        new r.MethodMirrorImpl(r"==", 131074, 1, -1, -1, -1, const <int>[0],
            const prefix0.Reflect(), const <Object>[]),
        new r.MethodMirrorImpl(r"toString", 131074, 1, -1, -1, -1,
            const <int>[], const prefix0.Reflect(), const <Object>[]),
        new r.MethodMirrorImpl(r"noSuchMethod", 65538, 1, null, -1, -1,
            const <int>[1], const prefix0.Reflect(), const <Object>[]),
        new r.MethodMirrorImpl(r"hashCode", 131075, 1, -1, -1, -1,
            const <int>[], const prefix0.Reflect(), const <Object>[]),
        new r.MethodMirrorImpl(r"runtimeType", 131075, 1, -1, -1, -1,
            const <int>[], const prefix0.Reflect(), const <Object>[]),
        new r.MethodMirrorImpl(r"", 128, 1, -1, -1, -1, const <int>[],
            const prefix0.Reflect(), const <Object>[])
      ],
      <m.ParameterMirror>[
        new r.ParameterMirrorImpl(r"other", 16390, 1, const prefix0.Reflect(),
            null, -1, -1, const <Object>[], null, null),
        new r.ParameterMirrorImpl(r"invocation", 32774, 3,
            const prefix0.Reflect(), -1, -1, -1, const <Object>[], null, null)
      ],
      <Type>[prefix1.Abstract, Object],
      2,
      {
        r"==": (dynamic instance) => (x) => instance == x,
        r"toString": (dynamic instance) => instance.toString,
        r"noSuchMethod": (dynamic instance) => instance.noSuchMethod,
        r"hashCode": (dynamic instance) => instance.hashCode,
        r"runtimeType": (dynamic instance) => instance.runtimeType
      },
      {},
      <m.LibraryMirror>[
        new r.LibraryMirrorImpl(r"", Uri.parse(r"reflectable://0/"),
            const prefix0.Reflect(), const <int>[], {}, {}, const [], null),
        new r.LibraryMirrorImpl(
            r"dart.core",
            Uri.parse(r"reflectable://1/dart.core"),
            const prefix0.Reflect(),
            const <int>[],
            {},
            {},
            const <Object>[],
            null)
      ],
      [])
};

final _memberSymbolMap = null;

initializeReflectable() {
  if (!isTransformed) {
    throw new UnsupportedError(
        "The transformed code is running with the untransformed "
        "reflectable package. Remember to set your package-root to "
        "'build/.../packages'.");
  }
  r.data = _data;
  r.memberSymbolMap = _memberSymbolMap;
}
