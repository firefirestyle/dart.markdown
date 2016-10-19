part of firefirestyle.markdown;

class BrObject extends GObject {
  BrObject() {}
  String toString() {
    return "<br>";
  }

  static Future<GObject> encode(par.MiniParser parser, GObject parent) async {
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
