import 'dart:convert';

import 'package:flutter/services.dart';

dynamic jsonFromFile(String name) async {
  String response = await rootBundle.loadString('assets/$name');
  return await jsonDecode(response);
}
