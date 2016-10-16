library firemarkdown;

import 'package:miniparser/core.dart' as par;
import 'dart:async';
import 'dart:convert' as conv;

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
    return BrObject.encode(parser);
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

class BrObject extends GObject {
  BrObject() {}
  String toString() {
    return "<br>";
  }

  static Future<GObject> encode(par.MiniParser parser) async {
    try {
      await parser.nextBytes([Markdown.cr,Markdown.lf,Markdown.cr,Markdown.lf]);
      return new BrObject();
    } catch(e){
      ;
    }

    await parser.nextBytes([Markdown.lf,Markdown.lf]);
    return new BrObject();
  }
}

class StrongObject extends GObject {
  List<int> content;

  StrongObject(this.content) {}
  String toString() {
    return "<em>${conv.UTF8.decode(content,allowMalformed: true)}</em>";
  }

  static Future<GObject> encode(par.MiniParser parser) async {
    List<int> cont = [];
    try {
      parser.push();
      if (false == await emStart(parser)) {
        throw Markdown.defaultError;
      }

      while (true) {
        if (true == await emEnd(parser)) {
          break;
        }
        //
        var v = await parser.readByte();
        cont.add(v);
      }
    } catch (e) {
      parser.back();
      throw e;
    } finally {
      parser.pop();
    }
    return new StrongObject(cont);
  }

  static Future<bool> emStart(par.MiniParser parser) async {
    bool ret = false;
    try {
      parser.push();
      await parser.nextBytes([Markdown.asterisk, Markdown.asterisk]);
      if (Markdown.space == await parser.readByte()) {
        throw Markdown.defaultError;
      }
      ret = true;
    } catch (e) {
      parser.back();
      ret = false;
    } finally {
      parser.pop();
    }
    return ret;
  }

  static Future<bool> emEnd(par.MiniParser parser) async {
    bool ret = false;
    try {
      parser.push();
      await parser.nextBytes([Markdown.asterisk, Markdown.asterisk]);
      ret = true;
    } catch (e) {
      parser.back();
      ret = false;
    } finally {
      parser.pop();
    }
    return ret;
  }
}

class HeadObject extends GObject {
  int id;
  List<int> content;

  HeadObject(this.id, this.content) {}
  String toString() {
    return "<h${this.id}>${conv.UTF8.decode(content,allowMalformed: true)}</h${this.id}>";
  }

  static Future<GObject> encode(par.MiniParser parser) async {
    parser.push();
    int numOfSharp = 0;
    try {
      numOfSharp = await headingSharp(parser);
      if (numOfSharp == 0) {
        throw Markdown.defaultError;
      }
      int numOfSpace = await headingSpace(parser);
      if (numOfSpace == 0) {
        parser.back();
        throw Markdown.defaultError;
      }
    } finally {
      parser.pop();
    }
    //
    List<int> ret = [];
    try {
      while (true) {
        var v = await parser.readByte();
        ret.add(v);
        if (v == Markdown.lf) {
          break;
        }
      }
    } catch (e) {} finally {}

    return new HeadObject(numOfSharp, ret);
  }

  //
  //
  //
  static Future<int> headingSharp(par.MiniParser parser) async {
    int sharpNum = 0;
    try {
      while (true) {
        await parser.nextByte(Markdown.sharp);
        sharpNum++;
      }
    } catch (e) {}
    return sharpNum;
  }

  static Future<int> headingSpace(par.MiniParser parser) async {
    int spaceNum = 0;
    try {
      while (true) {
        await parser.nextByte(Markdown.space);
        spaceNum++;
      }
    } catch (e) {}
    return spaceNum;
  }
}

class GObject {}


///
///
///
