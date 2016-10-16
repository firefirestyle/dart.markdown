part of firemarkdown;

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
