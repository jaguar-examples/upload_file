import 'dart:async';
import 'dart:html';
import 'package:http/browser_client.dart' as http;
import 'package:jaguar_client/jaguar_client.dart';
import 'package:stencil/stencil.dart';

JsonClient client = new JsonClient(new http.BrowserClient());

DivElement picHolder;

class PictureComp extends Component {
  final String url;

  PictureComp(this.url);

  String render() {
    return '''
<div class="item">
  <image src="/data/img/$url" class="item-img" width="45" height="45"></image>
  <span class="item-txt">$url</span>
</div>
    ''';
  }
}

class PictureListComp extends Component {
  final List<String> urls;

  PictureListComp(this.urls);

  String render() {
    return '''
<div>
  ${forEach(urls, (url) => comp(new PictureComp(url)))}
</div>
    ''';
  }
}

Future updatePics() async {
  final JsonResponse resp = await client.get('/api/pics');
  List<String> urls = resp.body;
  picHolder.setInnerHtml(new PictureListComp(urls).render());
}

main() async {
  final ButtonElement refreshBtn = querySelector("#refresh-btn");
  picHolder = querySelector("#pic-holder");

  refreshBtn.onClick.listen((_) async {
    print('here');
    await updatePics();
  });

  new Future.delayed(new Duration(seconds: 1)).then((_) {
    updatePics();
  });

}
