import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:theme_flutter/theme/theme_reader.dart';

void main() {
  test("Test add color input single depth", () {
    String _onlyColor = """
    {
      "colors": {
        "main": "#ff00ff",
        "secondary": "#fbfbfb",
        "mainText": "#ffbbff00",
        "secondaryText": "#ffbbff22"
      }
    }
    """;

    Map<String, String> _onlyColorExpectation = {
      "main": "#ff00ff",
      "secondary": "#fbfbfb",
      "mainText": "#ffbbff00",
      "secondaryText": "#ffbbff22"
    };

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.colors, _onlyColorExpectation);
    expect(theme.getColor("mainText"), Color(0xFFBBFF00));
    expect(theme.getColor("secondaryText"), Color(0xffbbff22));
  });

  test("Test add color input one deep", () {
    String _onlyColor = """
    {
      "colors": {
        "main": "#ff00ff",
        "mainText": "#ffbbff00",
        "secondaryText": "main"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("mainText"), Color(0xFFBBFF00));
    expect(theme.getColor("secondaryText"), Color(0xffff00ff));
  });

  test("Test add color input two deep", () {
    String _onlyColor = """
    {
      "colors": {
        "main": "#ff00ff",
        "mainText": "main",
        "secondaryText": "mainText"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("mainText"), Color(0xffff00ff));
    expect(theme.getColor("secondaryText"), Color(0xffff00ff));
  });

  test("Circular dependency one deep", (){
    String _onlyColor = """
    {
      "colors": {
        "main": "mainText",
        "mainText": "main"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("main"), null);
  });

  test("Circular dependency two deep", (){
    String _onlyColor = """
    {
      "colors": {
        "main": "secondaryText",
        "secondary": "#fbfbfb",
        "mainText": "main",
        "secondaryText": "mainText"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("main"), null);
  });
}
