part of firemarkdown;

class HeadObject extends GObject {
  int id;
  List<int> content;

  HeadObject(this.id, this.content) {}
  String toString() {
    return "<h${this.id}>${conv.UTF8.decode(content,allowMalformed: true)}</h${this.id}>";
  }

  static Future<GObject> encode(par.MiniParser parser, GObject parent) async {
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
