part of firemarkdown;

class LfObject extends GObject {
  LfObject() {}
  String toString() {
    return "";
  }

  static Future<GObject> encode(par.MiniParser parser, GObject parent) async {
    try {
      await parser.nextBytes([Markdown.cr,Markdown.lf]);
      return new LfObject();
    } catch(e){
      ;
    }
    await parser.nextBytes([Markdown.lf]);
    return new BrObject();
  }
}
