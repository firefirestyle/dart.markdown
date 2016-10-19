import 'package:test/test.dart' as unit;
import 'package:firefirestyle.firemarkdown/markdown.dart' as mar;
import 'package:miniparser/core.dart' as par;
import 'dart:convert' as conv;

void main() {
  unit.test("ps2", () async {
    var src = new par.BytesReader.fromList(conv.UTF8.encode("\r\n\r\n\n\n"),isImmutable: true);
    mar.Markdown markdownObj = new mar.Markdown(src);
    var gobj = await markdownObj.br();
    print(">>> ${gobj}");
    gobj = await markdownObj.br();
    print(">>> ${gobj}");
  });
}
