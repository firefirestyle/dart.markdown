library firemarkdown;

import 'package:miniparser/core.dart' as par;
import 'dart:async';
import 'dart:convert' as conv;

part 'src/headobject.dart';
part 'src/brobject.dart';
part 'src/strongobject.dart';

class GObject {}

class Markdown {
  static int sharp = 0x23; //#
  static int space = 0x20; //space
  static int asterisk = 0x2a;
  static int cr = 0x0d;
  static int lf = 0x0a;
  par.MiniParser parser;
  static Exception defaultError = new Exception();

  Markdown(par.Reader src) {
    this.parser = new par.MiniParser(src);
  }

  Future<GObject> encodeAll() async {
    return SourceObject.encode(parser);
  }

  Future<GObject> heading() async {
    return HeadObject.encode(parser);
  }

  Future<GObject> strong() async {
    return StrongObject.encode(parser);
  }
  Future<GObject> br() async {
    return StrongObject.encode(parser);
  }
}



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

class TextObject extends GObject {
  List<int> cont;
  TextObject(this.cont) {}
}
