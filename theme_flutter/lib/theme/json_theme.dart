import 'package:flutter/material.dart';
import 'package:theme_flutter/theme/theme_reader.dart';

class _InheritedJsonTheme extends InheritedWidget {
  const _InheritedJsonTheme({
    Key key,
    @required this.theme,
    @required Widget child,
  })  : assert(theme != null),
        super(key: key, child: child);

  final Theming theme;

  @override
  bool updateShouldNotify(_InheritedJsonTheme old) => theme != old.theme;
}

class JsonTheme extends StatelessWidget {
  final Theming _theming;
  final bool isMaterialAppTheme;
  final Widget child;

  JsonTheme({
    Key key,
    @required this.child,
    Theming theming,
    String json,
    this.isMaterialAppTheme = false,
  })  : assert(child != null),
        assert(json != null || theming != null),
        _theming = theming ?? Theming.fromJson(json),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final oldTheme = of(context);
    final overlaidTheme = oldTheme + _theming;

    return _InheritedJsonTheme(
      key: key,
      child: Theme(
        child: child,
        data: overlaidTheme.themeData,
        isMaterialAppTheme: isMaterialAppTheme,
      ),
      theme: overlaidTheme,
    );
  }

  static final Theming _kFallbackTheme = Theming.fallback();

  static Theming of(BuildContext context) {
    final _InheritedJsonTheme inheritedTheme =
        context.inheritFromWidgetOfExactType(_InheritedJsonTheme);
    return inheritedTheme?.theme ?? _kFallbackTheme;
  }
}
