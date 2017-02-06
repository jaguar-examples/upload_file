library upload_files.server;

import 'package:jaguar/jaguar.dart' as jaguar;
import 'package:jaguar_reflect/jaguar_reflect.dart';

import 'package:boilerplate/api.dart';

main(List<String> args) async {
  final ea = new JaguarReflected(new ExampleApi());

  final conf = new jaguar.Configuration(multiThread: true);
  conf.addApi(ea);

  await jaguar.serve(conf);
}
