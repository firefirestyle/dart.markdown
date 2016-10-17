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

  static Future<GObject> encode(par.MiniParser parser, GObject parent, {List<GObjectType> endOfTypes: null}) async {
    endOfTypes = (endOfTypes== null?[]:endOfTypes);
    SourceObject ret = new SourceObject();
    while (true) {
      try {
        ret.objList.add(await StrongObject.encode(parser, ret));
        continue;
      } catch (e) {}

      try {
        ret.objList.add(await HeadObject.encode(parser, ret));
        continue;
      } catch (e) {}

      try {
        parser.push();
        var v = await BrObject.encode(parser, ret);
        if (endOfTypes.contains(GObjectType.br)) {
          parser.back();
          break;
        } else {
          ret.objList.add(v);
        }
        continue;
      } catch (e) {
        parser.pop();
      }

      try {
        parser.push();
        var v = await LfObject.encode(parser, ret);
        if (endOfTypes.contains(GObjectType.lf)) {
          parser.back();
          break;
        } else {
          ret.objList.add(v);
        }
        continue;
      } catch (e) {
        parser.pop();
      }

      int v = 0;
      try {
        v = await parser.readByte();
      } catch (e) {
        break; // EOF
      }
      if (ret.objList.length > 0 && ret.objList.last is TextObject) {
        (ret.objList.last as TextObject).cont.add(v);
      } else {
        ret.objList.add(new TextObject([v]));
      }
    }
    return ret;
  }
}
