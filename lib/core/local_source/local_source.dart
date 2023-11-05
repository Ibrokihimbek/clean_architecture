import 'package:clean_architecture/constants/constants.dart';
import 'package:clean_architecture/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final class LocalSource {
  LocalSource(this.box);

  final Box<dynamic> box;

  void setLocale(String locale) {
    box.put(AppKeys.locale, locale);
  }

  String get locale => box.get(AppKeys.locale, defaultValue: defaultLocale);
}
