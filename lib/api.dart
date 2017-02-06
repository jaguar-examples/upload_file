library api;

import 'dart:async';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';

@Api(path: '/api')
class ExampleApi {
  @WrapDecodeFormData()
  @Post(path: '/upload')
  void upload(@Input(DecodeFormData) Map<String, FormField> formData) {
    print(formData['file']);
    //You have the file here. You can use 'dart:io' to save the file or use
    // jaguar_file_saver
  }
}
