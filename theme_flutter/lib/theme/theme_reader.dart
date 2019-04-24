import 'dart:convert';
import 'dart:ui';

class ThemeReader {}

class Theming {
  Map<String, dynamic> _colors = {};

  get colors => _colors;

  addInput(String input) {
    _colors = jsonDecode(input)['colors'];
  }

  //TODO: Check for circular dependency
  Color getColor(String key) {
    String color = _colors[key];
    if (color.contains("#")) {
      return _fromHex(color);
    } else {
      return getColor(color);
    }
  }
}

///Input a string formatted as such #AARRGGBB or #RRGGBB
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
