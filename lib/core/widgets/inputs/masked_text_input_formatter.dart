import 'package:flutter/services.dart';

class MaskedTextInputFormatter extends TextInputFormatter {
  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
    required this.filter,
  });

  final String mask;
  final String separator;
  final RegExp filter;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String text = newValue.text;
    final String newText = newValue.toJSON()['text'].toString();
    final String separatorWithText = newValue.text.replaceAll(separator, '');
    final Iterable<Match> matches = filter.allMatches(separatorWithText);
    if (matches.length != separatorWithText.length) return oldValue;
    if (text.isNotEmpty) {
      if (text.length > oldValue.text.length) {
        if (text.length > mask.length) return oldValue;
        if (text.length < mask.length && mask[text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${text.substring(text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
        if (text.length == mask.replaceAll(separator, '').length &&
            oldValue.text.isEmpty) {
          final StringBuffer bufferText = StringBuffer();
          int t = 0;
          for (int i = 0; i < text.length; i++) {
            if (mask[i + t] == separator) {
              bufferText.write(separator);
              t++;
            }
            bufferText.write(text[i]);
          }
          return TextEditingValue(
            text: bufferText.toString(),
            selection: TextSelection.collapsed(
              offset: bufferText.toString().length,
            ),
          );
        }
      } else {
        if (newText.substring(newText.length - 1) == separator) {
          return TextEditingValue(
            text: newValue.text.substring(0, newValue.text.length - 1),
            selection: TextSelection.collapsed(
              offset: newValue.selection.end - 1,
            ),
          );
        }
      }
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: newValue.selection.end,
        ),
      );
    }
    return newValue;
  }
}
