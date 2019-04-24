import 'dart:convert';
import 'dart:ui';

class ThemeReader {}

///Theme class
class Theming {
  Map<String, dynamic> _colors = {};
  Map<String, Color> _colorCache = {};

  get colors => _colors;

  Theming._internal();

  ///Creates a theme from json where theme data is parsed and places in the
  ///correct place
  factory Theming.fromJson(String theme) => Theming._internal()..overlay(theme);

  ///Overlays a new theme upon this one
  ///TODO: Implement actual overlaying instead of replacing
  overlay(String input) {
    _colors = jsonDecode(input)['colors'];
  }

  ///Gets the [Color] from the theme
  ///If color is not found or a circular dependency is found [NULL] is returned
  Color getColor(String key) {
    return _getColorInternal(key, []);
  }

  Color _getColorInternal(String key, List<String> hasTried) {
    return _colorCache.putIfAbsent(key, () {
      if (hasTried.contains(key)) {
        return null;
      }
      String color = _colors[key];
      if (color.contains("#")) {
        return _fromHex(color);
      } else {
        return _getColorInternal(color, hasTried..add(key));
      }
    });
  }
}

///Input a string formatted #AARRGGBB or #RRGGBB
Color _fromHex(String hexCode) {
  if (hexCode.startsWith('#')) {
    hexCode = hexCode.substring(1);
  }
  if (hexCode.length == 6) {
    hexCode = "FF" + hexCode;
  }

  List<String> hexDigits = hexCode.split('');
  int a = int.parse(hexDigits.sublist(0, 2).join(), radix: 16);
  int r = int.parse(hexDigits.sublist(2, 4).join(), radix: 16);
  int g = int.parse(hexDigits.sublist(4, 6).join(), radix: 16);
  int b = int.parse(hexDigits.sublist(6).join(), radix: 16);
  return Color.fromARGB(a, r, g, b);
}
