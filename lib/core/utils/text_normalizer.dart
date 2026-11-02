class TextNormalizer {
  const TextNormalizer._();

  static final RegExp _diacritics = RegExp('[\u064B-\u065F\u0670\u0640]');
  static final RegExp _alefVariants = RegExp('[\u0623\u0625\u0622\u0671]');
  static final RegExp _spaces = RegExp(r'\s+');

  static String normalize(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll(_diacritics, '')
        .replaceAll(_alefVariants, '\u0627')
        .replaceAll('\u0649', '\u064A')
        .replaceAll('\u0629', '\u0647')
        .replaceAll('-', ' ')
        .replaceAll(_spaces, ' ');
  }
}
