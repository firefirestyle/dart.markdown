library firemarkdown;

import 'package:miniparser/core.dart' as par;
import 'dart:async';
import 'dart:convert' as conv;

class Markdown {
  int sharp = 0x23; //#
  int space = 0x20; //space
  int cr = 0x0d;
  int lf = 0x0a;
  par.MiniParser parser;
  Exception defaultError = new Exception();

  Markdown(par.Reader src) {
    this.parser = new par.MiniParser(src);
  }

  Future<GObject> italic() async {
    return null;
  }

  Future<int> headingSharp() async {
    int sharpNum = 0;
    try {
      while (true) {
        await parser.nextByte(sharp);
        sharpNum++;
      }
    } catch (e) {}
    return sharpNum;
  }

  Future<int> headingSpace() async {
    int spaceNum = 0;
    try {
      while (true) {
        await parser.nextByte(space);
        spaceNum++;
      }
    } catch (e) {}
    return spaceNum;
  }

  Future<GObject> heading() async {
    parser.push();
    int numOfSharp = 0;
    try {
      numOfSharp = await headingSharp();
      if (numOfSharp == 0) {
        throw defaultError;
      }
      int numOfSpace = await headingSpace();
      if (numOfSpace == 0) {
        parser.back();
        throw defaultError;
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
        if (v == lf) {
          break;
        }
      }
    } catch (e) {} finally {}

    return new HeadObject(numOfSharp, ret);
  }
}

class HeadObject extends GObject {
  int id;
  List<int> content;

  HeadObject(this.id, this.content) {}
  String toString() {
    return "<h${this.id}>${conv.UTF8.decode(content,allowMalformed: true)}</h${this.id}>";
  }
}

class GObject {}
