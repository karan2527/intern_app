//All objects of this class are immutable, so we can use const constructor
class Quote {
  const Quote({required this.id, required this.content, required this.author});

  final int id;
  final String content;
  final String author;
}
