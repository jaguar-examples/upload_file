import 'dart:async';
import 'dart:html';
import 'package:http/browser_client.dart' as http;
import 'package:teja_http_json/teja_http_json.dart';
import 'package:static_dom/static_dom.dart';

JsonClient client = new JsonClient(new http.BrowserClient());

DivElement picHolder;

Future updatePics() async {
  final JsonResponse resp = await client.getJson('/api/pics');
  List<String> body = resp.body;
  Div div = d().forEach<String>(
      body,
      (String text) => d(classes: ['item'])
        ..add(i('/data/img/$text',
            classes: ["item-img"], width: "45px", height: "45px"))
        ..add(t(text, classes: ["item-txt"])));
  picHolder.setInnerHtml(div.render());
}

main() {
  final ButtonElement refreshBtn = querySelector("#refresh-btn");
  picHolder = querySelector("#pic-holder");

  refreshBtn.onClick.listen((_) async {
    await updatePics();
  });

  updatePics();
}
