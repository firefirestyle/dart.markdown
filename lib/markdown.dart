library firemarkdown;

import 'package:miniparser/core.dart' as par;
import 'dart:async';
import 'dart:convert' as conv;

class Markdown {
  int sharp = 0x23; //#
  int cr = 0x0d;
  int lf = 0x0a;
  par.MiniParser parser;

  Markdown(par.Reader src) {
    this.parser = new par.MiniParser(src);
  }

  Future<GObject> heading() async {
    int headingNumber = 0;
    try {
      parser.push();
      await parser.nextByte(sharp);
      headingNumber++;
    } catch (e) {
      if (headingNumber == 0) {
        throw e;
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

    return new HeadObject(headingNumber, ret);
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
