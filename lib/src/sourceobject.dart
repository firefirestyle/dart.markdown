
part of firemarkdown;

class SourceObject extends GObject {
  List<GObject> content = [];
  SourceObject() {}
  String toString() {
    StringBuffer buffer = new StringBuffer();
    for (var gobj in content) {
      buffer.write(gobj.toString());
    }
    return buffer.toString();
  }

  static Future<GObject> encode(par.MiniParser parser) async {
    SourceObject ret = new SourceObject();
    while (true) {
      try {
        ret.content.add(await StrongObject.encode(parser));
        continue;
      } catch (e) {}

      try {
        ret.content.add(await HeadObject.encode(parser));
        continue;
      } catch (e) {}

      try {
        ret.content.add(await BrObject.encode(parser));
        continue;
      } catch (e) {}

      int v = 0;
      try {
        v = await parser.readByte();
      } catch (e) {
        break;// EOF
      }
      if (ret.content.last is TextObject) {
        (ret.content.last as TextObject).cont.add(v);
      } else {
        ret.content.add(new TextObject([v]));
      }
      break;
    }
    return ret;
  }
}
