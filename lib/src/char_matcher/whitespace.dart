import 'char_matcher.dart';

class WhitespaceCharMatcher extends CharMatcher {
  const WhitespaceCharMatcher();

  @override
  bool match(int value) {
    if (value < 256) {
      switch (value) {
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 32:
        case 133:
        case 160:
          return true;
        default:
          return false;
      }
    } else {
      switch (value) {
        case 5760:
        case 8192:
        case 8193:
        case 8194:
        case 8195:
        case 8196:
        case 8197:
        case 8198:
        case 8199:
        case 8200:
        case 8201:
        case 8202:
        case 8232:
        case 8233:
        case 8239:
        case 8287:
        case 12288:
        case 65279:
          return true;
        default:
          return false;
      }
    }
  }
}
