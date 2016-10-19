part of firefirestyle.markdown;

class ListObject extends GObject {
  int numOfSpace;
  ListObject(this.numOfSpace) {}
  String toString() {
    return "li ${numOfSpace}:";
  }

  static Future<GObject> encode(par.MiniParser parser, GObject parent) async {
    if (await parent.isLineHead()) {
      try {
        parser.push();
        var numOfSpace = await Markdown.nextSpaces(parser);
        await parser.nextByte(Markdown.minus);
        await parser.nextByte(Markdown.space);
        var ret =  new ListObject(numOfSpace);
        ret.objList.add(await SourceObject.encode(parser, ret, endOfTypes: [GObjectType.br]));
        return ret;
      } catch (e) {
        parser.back();
        throw e;
      } finally {
        parser.pop();
      }
    } else {
      throw Markdown.defaultError;
    }
  }
}
