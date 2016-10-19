import 'package:test/test.dart' as unit;
import 'package:firefirestyle.markdown/markdown.dart' as mar;
import 'package:firefirestyle.miniparser/core.dart' as par;
import 'dart:convert' as conv;

void main() {
  unit.test("ps1", () async {
    var src = new par.BytesReader.fromList(conv.UTF8.encode("## asdfasdfasdfasd"),isImmutable: true);
    mar.Markdown markdownObj = new mar.Markdown(src);
    var gobj = await markdownObj.heading();
    print(">>> ${gobj}");
//    unit.expect(encode, "hello");
  });

}
