part of firemarkdown;

class HeadObject extends GObject {
  int id;

  HeadObject(this.id) {}
  String toString() {
    StringBuffer buffer = new StringBuffer();
    buffer.write("<h${this.id}>");
    for (var v in this.objList) {
      buffer.write(v);
    }
    buffer.write("</h${this.id}>");
    return buffer.toString();
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
    GObject ret = new HeadObject(numOfSharp);
    ret.objList.add(await SourceObject.encode(parser, ret, isEndAtLF: true));
    return ret;
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
