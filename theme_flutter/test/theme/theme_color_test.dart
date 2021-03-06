import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:theme_flutter/theme/theme_reader.dart';

void main() {
  test("Add color input single depth", () {
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

  test("Add color input one deep", () {
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

  test("Try to get a key that does not exist", (){
    String _onlyColor = """
    {
      "colors": {
        "main": "#ff00ff"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("DOES NOT EXIST!"), isNull);
  });

  test("Add color input two deep", () {
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

  test("Circular dependency one deep", () {
    String _onlyColor = """
    {
      "colors": {
        "main": "mainText",
        "mainText": "main"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("main"), isNull);
  });

  test("Circular dependency two deep", () {
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
    expect(theme.getColor("main"), isNull);
  });

  ///Test depth multiple times to get a clear picture of time savings when
  ///using cache
  test("Speed test cache multiple times", () {
    String _onlyColor = """
    {
      "colors": {
        "main": "#ff00ff",
        "mainText": "main",
        "secondaryText": "mainText",
        "secondaryText2": "secondaryText",
        "secondaryText3": "secondaryText2",
        "secondaryText4": "secondaryText3"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    for (int i = 0; i < 100000; i++) {
      expect(theme.getColor("mainText"), Color(0xffff00ff));
      expect(theme.getColor("secondaryText"), Color(0xffff00ff));
      expect(theme.getColor("secondaryText2"), Color(0xffff00ff));
      expect(theme.getColor("secondaryText3"), Color(0xffff00ff));
      expect(theme.getColor("secondaryText4"), Color(0xffff00ff));
    }
  });

  test("Overlay simple color values", () {
    String _onlyColor = """
    {
      "colors": {
        "main": "#ff00ff",
        "secondary": "#ffccaa"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("main"), Color(0xffff00ff));
    expect(theme.getColor("secondary"), Color(0xffffccaa));

    String _overlay = """
    {
      "colors": {
        "main": "#ffffff",
        "secondary": "#ffaacc"
      }
    }
    """;

    Theming overlayedTheme = theme.overlayJson(_overlay);
    expect(theme.getColor("main"), Color(0xffff00ff));
    expect(theme.getColor("secondary"), Color(0xffffccaa));
    expect(overlayedTheme.getColor("main"), Color(0xffffffff));
    expect(overlayedTheme.getColor("secondary"), Color(0xffffaacc));
  });

  test("Theme overlay change key to point to another point", () {
    String _onlyColor = """
    {
      "colors": {
        "main": "#ff00ff",
        "secondary": "#ffccaa",
        "mainText": "main",
        "secondaryText": "mainText"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("mainText"), Color(0xffff00ff));
    expect(theme.getColor("secondaryText"), Color(0xffff00ff));

    String _overlay = """
    {
      "colors": {
        "secondaryText": "secondary"
      }
    }
    """;

    Theming overlayedTheme = theme.overlayJson(_overlay);
    expect(theme.getColor("mainText"), Color(0xffff00ff));
    expect(theme.getColor("secondaryText"), Color(0xffff00ff));
    expect(overlayedTheme.getColor("mainText"), Color(0xffff00ff));
    expect(overlayedTheme.getColor("secondaryText"), Color(0xffffccaa));
  });

  test("Add key", () {
    String _onlyColor = """
    {
      "colors": {
        "main": "#ff00ff",
        "secondary": "#ffccaa",
        "mainText": "main",
        "secondaryText": "mainText"
      }
    }
    """;

    Theming theme = Theming.fromJson(_onlyColor);
    expect(theme.getColor("mainText"), Color(0xffff00ff));
    expect(theme.getColor("secondaryText"), Color(0xffff00ff));
    expect(theme.getColor("thirdText"), isNull);
    expect(theme.getColor("colorDirect"), isNull);

    String _overlay = """
    {
      "colors": {
        "thirdText": "secondaryText",
        "colorDirect": "#00ff00ff"
      }
    }
    """;

    Theming overlayedTheme = theme.overlayJson(_overlay);
    expect(theme.getColor("mainText"), Color(0xffff00ff));
    expect(theme.getColor("secondaryText"), Color(0xffff00ff));
    expect(theme.getColor("thirdText"), isNull);
    expect(theme.getColor("colorDirect"), isNull);
    expect(overlayedTheme.getColor("mainText"), Color(0xffff00ff));
    expect(overlayedTheme.getColor("secondaryText"), Color(0xffff00ff));
    expect(overlayedTheme.getColor("thirdText"), Color(0xffff00ff));
    expect(overlayedTheme.getColor("colorDirect"), Color(0x00ff00ff));
  });
}
