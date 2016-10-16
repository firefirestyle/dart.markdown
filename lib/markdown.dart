library firemarkdown;

import 'package:miniparser/core.dart' as par;
import 'dart:async';
import 'dart:convert' as conv;

part 'src/headobject.dart';
part 'src/brobject.dart';
part 'src/strongobject.dart';
part 'src/sourceobject.dart';

class GObject {}

class TextObject extends GObject {
  List<int> cont;
  TextObject(this.cont) {}
}

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

class ListObject extends GObject {
  int id;
  List<int> content;
  ListObject(this.id, this.content) {}
  String toString() {
    return "<h${this.id}>${conv.UTF8.decode(content,allowMalformed: true)}</h${this.id}>";
  }

  static Future<GObject> encode(par.MiniParser parser) async {
//    parser.next
  }

}
