library upload_files.server;

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

import 'package:boilerplate/api.dart';

main(List<String> args) async {
  final ea = reflectJaguar(new ExampleApi());

  final conf = new Jaguar(multiThread: true);
  conf.addApi(ea);

  await conf.serve();
}
