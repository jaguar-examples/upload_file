library upload_files.server;

import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';
import 'package:jaguar_static_file/jaguar_static_file.dart';

import 'package:boilerplate/api.dart';

main(List<String> args) async {
  final ea = reflectJaguar(new ExampleApi());

  // Proxy all html client requests to pub server
  final proxy = new PrefixedProxyServer('/', 'http://localhost:8082/');
  final images = new StaticServer('/data/img/', new Directory('bin/data'));

  final conf = new Jaguar(multiThread: true);
  conf.addApi(ea);
  conf.addApi(proxy);
  conf.addApi(images);

  await conf.serve();
}
