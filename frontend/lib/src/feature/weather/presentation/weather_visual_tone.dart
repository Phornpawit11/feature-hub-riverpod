import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_models.dart';

@immutable
class WeatherVisualTone {
  const WeatherVisualTone({
    required this.scaffoldBackground,
    required this.backdropColors,
    required this.backdropStops,
    required this.orbTopLeft,
    required this.orbTopRight,
    required this.orbBottomLeft,
    required this.panelGradientStart,
    required this.panelGradientEnd,
    required this.panelBorder,
    required this.panelShadow,
    required this.surfaceTint,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconGradientStart,
    required this.iconGradientEnd,
    required this.iconShadow,
    required this.iconForeground,
    required this.buttonBackground,
    required this.buttonForeground,
    required this.metricFill,
    required this.metricBorder,
  });

  final Color scaffoldBackground;
  final List<Color> backdropColors;
  final List<double> backdropStops;
  final List<Color> orbTopLeft;
  final List<Color> orbTopRight;
  final List<Color> orbBottomLeft;
  final Color panelGradientStart;
  final Color panelGradientEnd;
  final Color panelBorder;
  final Color panelShadow;
  final Color surfaceTint;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color iconGradientStart;
  final Color iconGradientEnd;
  final Color iconShadow;
  final Color iconForeground;
  final Color buttonBackground;
  final Color buttonForeground;
  final Color metricFill;
  final Color metricBorder;
}

enum WeatherToneKind {
  neutral,
  clearDay,
  clearNight,
  cloudy,
  rain,
  thunderstorm,
  snow,
  mist,
}

WeatherToneKind resolveWeatherToneKind(CurrentWeather current) {
  final condition = current.condition.trim().toLowerCase();
  final description = current.description.trim().toLowerCase();
  final iconCode = current.iconCode.trim().toLowerCase();
  final isNight = iconCode.endsWith('n');

  if (condition.contains('thunderstorm') || description.contains('thunder')) {
    return WeatherToneKind.thunderstorm;
  }
  if (condition.contains('snow') || description.contains('snow')) {
    return WeatherToneKind.snow;
  }
  if (condition.contains('mist') ||
      condition.contains('fog') ||
      condition.contains('haze') ||
      description.contains('mist') ||
      description.contains('fog') ||
      description.contains('haze') ||
      description.contains('smoke')) {
    return WeatherToneKind.mist;
  }
  if (condition.contains('rain') ||
      condition.contains('drizzle') ||
      description.contains('rain') ||
      description.contains('drizzle')) {
    return WeatherToneKind.rain;
  }
  if (condition.contains('clear') || description.contains('clear')) {
    return isNight ? WeatherToneKind.clearNight : WeatherToneKind.clearDay;
  }
  if (condition.contains('cloud')) {
    return WeatherToneKind.cloudy;
  }
  if (isNight) {
    return WeatherToneKind.clearNight;
  }
  return WeatherToneKind.cloudy;
}

WeatherVisualTone resolveWeatherTone(CurrentWeather current) {
  return toneForKind(resolveWeatherToneKind(current));
}

WeatherVisualTone loadingWeatherTone() => toneForKind(WeatherToneKind.neutral);

WeatherVisualTone toneForKind(WeatherToneKind kind) {
  return switch (kind) {
    WeatherToneKind.clearDay => const WeatherVisualTone(
      scaffoldBackground: Color(0xFF6D8ED8),
      backdropColors: [
        Color(0xFF8FCAFF),
        Color(0xFF6B9CF4),
        Color(0xFFF6B074),
        Color(0xFF304982),
      ],
      backdropStops: [0.0, 0.38, 0.72, 1.0],
      orbTopLeft: [Color(0x80FFF2AB), Color(0x00FFF2AB)],
      orbTopRight: [Color(0x6EB8E7FF), Color(0x00B8E7FF)],
      orbBottomLeft: [Color(0x4DE7F1FF), Color(0x00E7F1FF)],
      panelGradientStart: Color(0x47FFFFFF),
      panelGradientEnd: Color(0x1FD9ECFF),
      panelBorder: Color(0x66FFFFFF),
      panelShadow: Color(0x2A173158),
      surfaceTint: Color(0x1CF2F8FF),
      textPrimary: Color(0xFFF9FDFF),
      textSecondary: Color(0xD6F5FAFF),
      textTertiary: Color(0xA8E3EBF7),
      iconGradientStart: Color(0xFFFFF0AB),
      iconGradientEnd: Color(0xFFFFAF6B),
      iconShadow: Color(0x52FFAD6C),
      iconForeground: Color(0xFF5B371C),
      buttonBackground: Color(0x2EF7FBFF),
      buttonForeground: Color(0xFFF8FDFF),
      metricFill: Color(0x20F7FBFF),
      metricBorder: Color(0x29FFFFFF),
    ),
    WeatherToneKind.clearNight => const WeatherVisualTone(
      scaffoldBackground: Color(0xFF0C1332),
      backdropColors: [
        Color(0xFF182457),
        Color(0xFF2C2A6B),
        Color(0xFF443163),
        Color(0xFF090D1C),
      ],
      backdropStops: [0.0, 0.32, 0.68, 1.0],
      orbTopLeft: [Color(0x5AAFD0FF), Color(0x00AFD0FF)],
      orbTopRight: [Color(0x52FFE5AE), Color(0x00FFE5AE)],
      orbBottomLeft: [Color(0x4EBFA3FF), Color(0x00BFA3FF)],
      panelGradientStart: Color(0x34EDF2FF),
      panelGradientEnd: Color(0x164A5DB6),
      panelBorder: Color(0x57ECF3FF),
      panelShadow: Color(0x42040A1D),
      surfaceTint: Color(0x18385CF0),
      textPrimary: Color(0xFFF4F7FF),
      textSecondary: Color(0xD0DCEEFF),
      textTertiary: Color(0xA5BACFFF),
      iconGradientStart: Color(0xFFFFE7B0),
      iconGradientEnd: Color(0xFF9EB8FF),
      iconShadow: Color(0x4F8AA5FF),
      iconForeground: Color(0xFF2C2338),
      buttonBackground: Color(0x2A8BAEFF),
      buttonForeground: Color(0xFFF6FAFF),
      metricFill: Color(0x1D99B6FF),
      metricBorder: Color(0x2CEAF5FF),
    ),
    WeatherToneKind.cloudy => const WeatherVisualTone(
      scaffoldBackground: Color(0xFF425172),
      backdropColors: [
        Color(0xFF7788A8),
        Color(0xFF667594),
        Color(0xFF8D7F9F),
        Color(0xFF1B243D),
      ],
      backdropStops: [0.0, 0.36, 0.7, 1.0],
      orbTopLeft: [Color(0x64D7E4FF), Color(0x00D7E4FF)],
      orbTopRight: [Color(0x55FFD6D1), Color(0x00FFD6D1)],
      orbBottomLeft: [Color(0x4FBCAEFF), Color(0x00BCAEFF)],
      panelGradientStart: Color(0x39FFFFFF),
      panelGradientEnd: Color(0x177B8AAE),
      panelBorder: Color(0x57EEF4FF),
      panelShadow: Color(0x34111724),
      surfaceTint: Color(0x1BCCE0FF),
      textPrimary: Color(0xFFF8FBFF),
      textSecondary: Color(0xD6E2F1FF),
      textTertiary: Color(0xAFC6D6E8),
      iconGradientStart: Color(0xFFE3EEFF),
      iconGradientEnd: Color(0xFFA7BBE7),
      iconShadow: Color(0x477A92D2),
      iconForeground: Color(0xFF33405E),
      buttonBackground: Color(0x27D6E0FF),
      buttonForeground: Color(0xFFF8FBFF),
      metricFill: Color(0x1AD5E2FF),
      metricBorder: Color(0x24FFFFFF),
    ),
    WeatherToneKind.rain => const WeatherVisualTone(
      scaffoldBackground: Color(0xFF1A2748),
      backdropColors: [
        Color(0xFF314C75),
        Color(0xFF263B61),
        Color(0xFF294669),
        Color(0xFF0A1222),
      ],
      backdropStops: [0.0, 0.34, 0.68, 1.0],
      orbTopLeft: [Color(0x5B9BC7FF), Color(0x009BC7FF)],
      orbTopRight: [Color(0x416F92FF), Color(0x006F92FF)],
      orbBottomLeft: [Color(0x46C2D7FF), Color(0x00C2D7FF)],
      panelGradientStart: Color(0x2DE5F6FF),
      panelGradientEnd: Color(0x1327426C),
      panelBorder: Color(0x4DE7F7FF),
      panelShadow: Color(0x3D030913),
      surfaceTint: Color(0x163B6D9D),
      textPrimary: Color(0xFFF6FBFF),
      textSecondary: Color(0xD0DDEDFF),
      textTertiary: Color(0xA6BED2E8),
      iconGradientStart: Color(0xFFCADDFF),
      iconGradientEnd: Color(0xFF74A6D8),
      iconShadow: Color(0x4A5DA4D6),
      iconForeground: Color(0xFF21304D),
      buttonBackground: Color(0x2876A6D4),
      buttonForeground: Color(0xFFF7FCFF),
      metricFill: Color(0x176D9FCE),
      metricBorder: Color(0x23DCF1FF),
    ),
    WeatherToneKind.thunderstorm => const WeatherVisualTone(
      scaffoldBackground: Color(0xFF140F2E),
      backdropColors: [
        Color(0xFF322357),
        Color(0xFF211A46),
        Color(0xFF3B2E67),
        Color(0xFF060913),
      ],
      backdropStops: [0.0, 0.36, 0.7, 1.0],
      orbTopLeft: [Color(0x61B3B9FF), Color(0x00B3B9FF)],
      orbTopRight: [Color(0x60C2A8FF), Color(0x00C2A8FF)],
      orbBottomLeft: [Color(0x5EA47CFF), Color(0x00A47CFF)],
      panelGradientStart: Color(0x32D4CCFF),
      panelGradientEnd: Color(0x164B337F),
      panelBorder: Color(0x57CDF5FF),
      panelShadow: Color(0x4D04050D),
      surfaceTint: Color(0x18314B8C),
      textPrimary: Color(0xFFF6F9FF),
      textSecondary: Color(0xD2D9F9FF),
      textTertiary: Color(0xADBAE3F4),
      iconGradientStart: Color(0xFFECF0FF),
      iconGradientEnd: Color(0xFFA38BF8),
      iconShadow: Color(0x5A7E63FF),
      iconForeground: Color(0xFF2A2240),
      buttonBackground: Color(0x2E7CB2FF),
      buttonForeground: Color(0xFFF7FCFF),
      metricFill: Color(0x1C7EA6FF),
      metricBorder: Color(0x23D5ECFF),
    ),
    WeatherToneKind.snow => const WeatherVisualTone(
      scaffoldBackground: Color(0xFFB8CBE2),
      backdropColors: [
        Color(0xFFE8F5FF),
        Color(0xFFCBE0F3),
        Color(0xFFB5D1E8),
        Color(0xFF6483A2),
      ],
      backdropStops: [0.0, 0.34, 0.72, 1.0],
      orbTopLeft: [Color(0x75FFFFFF), Color(0x00FFFFFF)],
      orbTopRight: [Color(0x58DDEEFF), Color(0x00DDEEFF)],
      orbBottomLeft: [Color(0x5FC8E6FF), Color(0x00C8E6FF)],
      panelGradientStart: Color(0x4DFFFFFF),
      panelGradientEnd: Color(0x20DFF4FF),
      panelBorder: Color(0x80FFFFFF),
      panelShadow: Color(0x28122436),
      surfaceTint: Color(0x1CE3F5FF),
      textPrimary: Color(0xFFFDFEFF),
      textSecondary: Color(0xE0F8FBFF),
      textTertiary: Color(0xB3D7EAF4),
      iconGradientStart: Color(0xFFFFFFFF),
      iconGradientEnd: Color(0xFFC5E4FF),
      iconShadow: Color(0x52A6D2F4),
      iconForeground: Color(0xFF35506E),
      buttonBackground: Color(0x2CCFE8FF),
      buttonForeground: Color(0xFFFDFEFF),
      metricFill: Color(0x22E9F6FF),
      metricBorder: Color(0x42FFFFFF),
    ),
    WeatherToneKind.mist => const WeatherVisualTone(
      scaffoldBackground: Color(0xFF5E6D7E),
      backdropColors: [
        Color(0xFFC7D1DA),
        Color(0xFFAEB8C2),
        Color(0xFF8B9BAA),
        Color(0xFF33404D),
      ],
      backdropStops: [0.0, 0.34, 0.68, 1.0],
      orbTopLeft: [Color(0x5AFFFFFF), Color(0x00FFFFFF)],
      orbTopRight: [Color(0x4FD8E0E7), Color(0x00D8E0E7)],
      orbBottomLeft: [Color(0x44C6D1DB), Color(0x00C6D1DB)],
      panelGradientStart: Color(0x40FFFFFF),
      panelGradientEnd: Color(0x19C7D1DD),
      panelBorder: Color(0x67F7FBFF),
      panelShadow: Color(0x2812161D),
      surfaceTint: Color(0x16E2EBF2),
      textPrimary: Color(0xFFFAFCFE),
      textSecondary: Color(0xD7E7F1F7),
      textTertiary: Color(0xB0C8D3DE),
      iconGradientStart: Color(0xFFF4F8FC),
      iconGradientEnd: Color(0xFFCED7DF),
      iconShadow: Color(0x4494B2C8),
      iconForeground: Color(0xFF48535F),
      buttonBackground: Color(0x24D7E4ED),
      buttonForeground: Color(0xFFF9FCFE),
      metricFill: Color(0x18E7EFF4),
      metricBorder: Color(0x2AFFFFFF),
    ),
    WeatherToneKind.neutral => const WeatherVisualTone(
      scaffoldBackground: Color(0xFF0F1630),
      backdropColors: [
        Color(0xFF4A5FD1),
        Color(0xFF6C4BA8),
        Color(0xFFEF8B61),
        Color(0xFF121A35),
      ],
      backdropStops: [0.0, 0.35, 0.72, 1.0],
      orbTopLeft: [Color(0x808EC5FF), Color(0x008EC5FF)],
      orbTopRight: [Color(0x6BFFB27A), Color(0x00FFB27A)],
      orbBottomLeft: [Color(0x52C1A3FF), Color(0x00C1A3FF)],
      panelGradientStart: Color(0x40FFFFFF),
      panelGradientEnd: Color(0x1AFFFFFF),
      panelBorder: Color(0x57FFFFFF),
      panelShadow: Color(0x26000000),
      surfaceTint: Color(0x1BFFFFFF),
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xC7FFFFFF),
      textTertiary: Color(0xA3FFFFFF),
      iconGradientStart: Color(0xFFFFD58E),
      iconGradientEnd: Color(0xFFFF996B),
      iconShadow: Color(0x4CFFAB7B),
      iconForeground: Color(0xFF553116),
      buttonBackground: Color(0x24FFFFFF),
      buttonForeground: Color(0xFFFFFFFF),
      metricFill: Color(0x1CFFFFFF),
      metricBorder: Color(0x1FFFFFFF),
    ),
  };
}
