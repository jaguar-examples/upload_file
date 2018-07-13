library upload_files.server;

import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';

main(List<String> args) async {
  final server = Jaguar(port: 8005);

  // API
  server.group('/api')
    // Upload route
    ..post('/upload', (ctx) async {
      final Map<String, FormField> formData = await ctx.bodyAsFormData();
      BinaryFileFormField pic = formData['pic'];
      File file = new File('bin/data/' + pic.filename);
      IOSink sink = file.openWrite();
      await sink.addStream(pic.value);
      await sink.close();
      return Redirect(Uri.parse("/"));
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
  server.staticFiles('/data/img/*', 'bin/data');
  // Serve HTML and related files
  server.add(new PrefixedProxyServer('/', 'http://localhost:8000/'));

  server.log.onRecord.listen(print);

  await server.serve(logRequests: true);
}
