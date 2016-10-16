
part of firemarkdown;

class SourceObject extends GObject {

  SourceObject() {}
  String toString() {
    StringBuffer buffer = new StringBuffer();
    for (var gobj in objList) {
      buffer.write(gobj.toString());
    }
    return buffer.toString();
  }

  static Future<GObject> encode(par.MiniParser parser, GObject parent) async {
    SourceObject ret = new SourceObject();
    while (true) {
      try {
        ret.objList.add(await StrongObject.encode(parser,ret));
        continue;
      } catch (e) {}

      try {
        ret.objList.add(await HeadObject.encode(parser,ret));
        continue;
      } catch (e) {}

      try {
        ret.objList.add(await BrObject.encode(parser,ret));
        continue;
      } catch (e) {}

      int v = 0;
      try {
        v = await parser.readByte();
      } catch (e) {
        break;// EOF
      }
      if (ret.objList.last is TextObject) {
        (ret.objList.last as TextObject).cont.add(v);
      } else {
        ret.objList.add(new TextObject([v]));
      }
      break;
    }
    return ret;
  }
}
