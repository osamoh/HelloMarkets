import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageHelper {
  static Future<String> imageToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  static base64ToImage(String base64ImageString) {
    return base64Decode(base64ImageString);
  }
}