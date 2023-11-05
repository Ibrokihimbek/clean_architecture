part of 'package:clean_architecture/core/theme/themes.dart';

class ThemeGradients extends ThemeExtension<ThemeGradients> {
  const ThemeGradients();

  static const light = ThemeGradients();
  static const dark = ThemeGradients();

  @override
  ThemeExtension<ThemeGradients> copyWith() => light;

  @override
  ThemeExtension<ThemeGradients> lerp(
      ThemeExtension<ThemeGradients>? other, double t) {
    if (other is! ThemeGradients) {
      return this;
    }
    return light;
  }
}

extension BuildContextZ on BuildContext {
  ThemeGradients get gradients => Theme.of(this).extension<ThemeGradients>()!;
}
