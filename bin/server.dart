library upload_files.server;

import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';
import 'package:jaguar_static_file/jaguar_static_file.dart';

main(List<String> args) async {
  final server = new Jaguar(port: 8005);

  // API
  server.group('/api')
    // Upload route
    ..post('/upload', (ctx) async {
      final Map<String, FormField> formData = await ctx.req.bodyAsFormData();
      BinaryFileFormField pic = formData['pic'];
      File file = new File('bin/data/' + pic.filename);
      IOSink sink = file.openWrite();
      await sink.addStream(pic.value);
      await sink.close();
      return Response.redirect(Uri.parse("/"));
    })
    // Get uploaded media route
    ..get('/pics', (Context ctx) async {
      Directory dir = new Directory('bin/data');

      List<String> pics = [];

      await for (FileSystemEntity entity in dir.list()) {
        if (!await FileSystemEntity.isFile(entity.path)) continue;

        if (!entity.path.endsWith('.jpg')) continue;

        pics.add(entity.uri.pathSegments.last);
      }

      return Response.json(pics);
    });

  // Serve the uploaded media
  server.addApi(new StaticFileHandler('/data/img/', new Directory('bin/data')));
  // Serve HTML and related files
  server.addApi(new PrefixedProxyServer('/', 'http://localhost:8000/'));

  await server.serve();
}
