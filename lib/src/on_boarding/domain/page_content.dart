import 'package:sikshya/core/res/media_res.dart';

class PageContent {
  const PageContent({
    required this.image,
    required this.title,
    required this.desc,
  });
  const PageContent.first()
      : this(
          image: MediaRes.casualReading,
          title: 'Brand New Ways to Studying',
          desc: "Explore 'Brand New Ways to Studying' and transform your "
              ' learning journey. Unlock innovative techniques for improved'
              '  knowledge retention and academic achievement.',
        );
  const PageContent.second()
      // ignore: lines_longer_than_80_chars
      : this(
          image: MediaRes.casualMeditation,
          title: 'Learn like you are meditating.',
          desc:
              '"Learn like you are meditating, embracing a tranquil approach to'
              ' acquiring knowledge that promotes focus and deep understanding.',
        );
  const PageContent.third()
      : this(
          image: MediaRes.casualLife,
          title: 'Learn wherever you are whatever you are doing.',
          desc:
              'Learn wherever you are, whatever you are doing, and seamlessly '
              'integrate education into your daily life for continuous growth '
              ' and self-improvement',
        );

  final String image;
  final String title;
  final String desc;
}
