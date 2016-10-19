library firefirestyle.markdown;

import 'package:miniparser/core.dart' as par;
import 'dart:async';
import 'dart:convert' as conv;

part 'src/headobject.dart';
part 'src/brobject.dart';
part 'src/lfobject.dart';
part 'src/strongobject.dart';
part 'src/sourceobject.dart';
part 'src/listobject.dart';

enum GObjectType { empty, text, br, lf, string, source, list, }

class GObject {
  List<GObject> objList = [];
  Future<bool> isLineHead() async {
    if (this.objList.length == 0) {
      return true;
    } else if (this.objList.last is BrObject) {
      return true;
    } else if (this.objList.last is LfObject) {
      return true;
    } else {
      return false;
    }
  }
}

class TextObject extends GObject {
  List<int> cont;
  TextObject(this.cont) {}
  String toString() {
    return conv.UTF8.decode(cont, allowMalformed: true);
  }
}

class Markdown {
  static int sharp = 0x23; //#
  static int space = 0x20; //space
  static int asterisk = 0x2a;
  static int cr = 0x0d;
  static int lf = 0x0a;
  static int minus = 0x2d;
  par.MiniParser parser;
  GObject rootObj = new GObject();
  static Exception defaultError = new Exception();

  Markdown(par.Reader src) {
    this.parser = new par.MiniParser(src);
  }

  static Future<int> nextSpaces(par.MiniParser parser) async {
    int spaceNum = 0;
    try {
      while (true) {
        await parser.nextByte(Markdown.space);
        spaceNum++;
      }
    } catch (e) {}
    return spaceNum;
  }

  Future<GObject> encodeAll() async {
    return SourceObject.encode(parser, rootObj);
  }

  Future<GObject> heading() async {
    return HeadObject.encode(parser, rootObj);
  }

  Future<GObject> strong() async {
    return StrongObject.encode(parser, rootObj);
  }

  Future<GObject> br() async {
    return StrongObject.encode(parser, rootObj);
  }
}
