library upload_files.client;

import 'dart:io';
import 'package:http/http.dart' as http;

final url = 'http://localhost:8080/api/upload';
final uploadFilename = 'bin/data/sample.txt';

main() async {
  final file = new File(uploadFilename);
  final uri = Uri.parse(url);
  final request = new http.MultipartRequest("POST", uri);
  request.fields['as'] = 'file.txt';
  request.files.add(new http.MultipartFile(
      'file', file.openRead(), await file.length(),
      filename: 'sample.txt'));
  await request.send();
}
