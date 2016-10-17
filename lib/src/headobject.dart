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
    if(false == await parent.isLineHead()){
      throw Markdown.defaultError;
    }
    parser.push();
    int numOfSharp = 0;
    try {
      numOfSharp = await headingSharp(parser);
      if (numOfSharp == 0) {
        throw Markdown.defaultError;
      }
      int numOfSpace = await Markdown.nextSpaces(parser);
      if (numOfSpace == 0) {
        parser.back();
        throw Markdown.defaultError;
      }
    } finally {
      parser.pop();
    }
    GObject ret = new HeadObject(numOfSharp);
    ret.objList.add(await SourceObject.encode(parser, ret, endOfTypes: [GObjectType.br,GObjectType.lf]));
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


}
