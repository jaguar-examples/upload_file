library api;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';

@Api(path: '/api')
class ExampleApi {
  @Post(path: '/upload')
  Future<Response<Uri>> upload(Context ctx) async {
    final Map<String, FormField> formData = await ctx.req.bodyAsFormData();
    BinaryFileFormField pic = formData['pic'];
    File file = new File('bin/data/' + pic.filename);
    IOSink sink = file.openWrite();
    await sink.addStream(pic.value);
    await sink.close();
    return Response.redirect(Uri.parse("/"));
  }

  @Get(path: '/pics')
  Future<Response<String>> listPics(Context ctx) async {
    Directory dir = new Directory('bin/data');

    List<String> pics = [];

    await for(FileSystemEntity entity in dir.list()) {
      if(!await FileSystemEntity.isFile(entity.path)) continue;

      if(!entity.path.endsWith('.jpg')) continue;

      pics.add(entity.uri.pathSegments.last);
    }

    return Response.json(pics);
  }
}
