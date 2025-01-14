import '../../../math.dart';
import '../builder.dart';
import '../printer.dart';
import '../string/pad.dart';
import '../string/separate.dart';
import 'sign.dart';
import 'utils.dart';

/// Prints numbers in a fixed format.
class FixedNumberPrinter<T extends num> extends Printer<T> {
  /// Round towards the nearest number that is a multiple of accuracy.
  final double? accuracy;

  /// The numeric base to which the number should be printed.
  final int base;

  /// The characters to be used to convert a number to a string.
  final String characters;

  /// The delimiter to separate the integer and fraction part of the number.
  final String delimiter;

  /// The string that should be displayed if the number is infinite.
  final String infinity;

  /// The string that should be displayed if the number is not a number.
  final String nan;

  /// The number of digits to be printed in the integer part.
  final int padding;

  /// The number of digits to be printed in the fraction part.
  final int precision;

  /// The separator character to be used to group digits.
  final String separator;

  /// The printer used for negative or positive numbers.
  final Printer<T> sign;

  /// Internal integer printer.
  final Printer<String> _integer;

  /// Internal fraction printer.
  final Printer<String> _fraction;

  /// Prints numbers in a custom fixed format.
  FixedNumberPrinter({
    this.accuracy,
    this.base = 10,
    this.characters = lowerCaseDigits,
    this.delimiter = delimiterString,
    this.infinity = infinityString,
    this.nan = nanString,
    this.padding = 0,
    this.precision = 0,
    this.separator = '',
    Printer<T>? sign,
  })  : sign = sign ?? SignNumberPrinter<T>.omitPositiveSign(),
        _integer = const Printer<String>.standard()
            .mapIf(padding > 0,
                (printer) => printer.padLeft(padding, characters[0]))
            .mapIf(separator.isNotEmpty,
                (printer) => printer.separateRight(3, 0, separator)),
        _fraction = const Printer<String>.standard()
            .mapIf(precision > 0,
                (printer) => printer.padLeft(precision, characters[0]))
            .mapIf(separator.isNotEmpty,
                (printer) => printer.separateLeft(3, 0, separator));

  @override
  void printOn(T object, StringBuffer buffer) {
    sign.printOn(object, buffer);
    if (object.isNaN) {
      buffer.write(nan);
    } else if (object.isInfinite) {
      buffer.write(infinity);
    } else {
      _printNumOn(object, buffer);
    }
  }

  void _printNumOn(num value, StringBuffer buffer) {
    final multiplier = base.pow(precision);
    final rounding = accuracy ?? 1.0 / multiplier;
    final rounded = (value / rounding).roundToDouble() * rounding;
    _printIntegerOn(rounded, buffer);
    if (precision > 0) {
      buffer.write(delimiter);
      final fractional = rounded.abs() - rounded.abs().truncate();
      _printFractionOn(fractional * multiplier, buffer);
    }
  }

  void _printIntegerOn(num value, StringBuffer buffer) {
    final digits = intDigits(value.abs().truncate(), base);
    _printIntegerDigitsOn(digits, buffer);
  }

  void _printIntegerDigitsOn(Iterable<int> digits, StringBuffer buffer) {
    final result = formatDigits(digits, characters);
    _integer.printOn(result, buffer);
  }

  void _printFractionOn(double value, StringBuffer buffer) {
    final digits = intDigits(value.round(), base);
    final result = formatDigits(digits, characters);
    _fraction.printOn(result, buffer);
  }
}
