import 'package:api_learn/models/book_model.dart';
import 'package:api_learn/models/chapterModel.dart';

class HadisModel {
  String? id;
  String? hadithNumber;
  String? englishNarrator;
  String? hadithEnglish;
  String? hadithUrdu;
  String? urduNarrator;
  String? hadithArabic;
  String? chapterId;
  String? bookSlug;
  String? volume;
  BookModel? book;
  ChapterModel? chapter;

  HadisModel(
      {this.id,
      this.hadithNumber,
      this.englishNarrator,
      this.hadithEnglish,
      this.hadithUrdu,
      this.urduNarrator,
      this.hadithArabic,
      this.chapterId,
      this.bookSlug,
      this.volume,
      this.book,
      this.chapter});

  HadisModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null' ? '' : json['id'].toString();
    hadithNumber = json['hadithNumber'].toString() == 'null'
        ? ''
        : json['hadithNumber'].toString();
    englishNarrator = json['englishNarrator'].toString() == 'null'
        ? ''
        : json['englishNarrator'].toString();
    hadithEnglish = json['hadithEnglish'].toString() == 'null'
        ? ''
        : json['hadithEnglish'].toString();
    hadithUrdu = json['hadithUrdu'].toString() == 'null'
        ? ''
        : json['hadithUrdu'].toString();
    urduNarrator = json['urduNarrator'].toString() == 'null'
        ? ''
        : json['urduNarrator'].toString();
    hadithArabic = json['hadithArabic'].toString() == 'null'
        ? ''
        : json['hadithArabic'].toString();
    chapterId = json['chapterId'].toString() == 'null'
        ? ''
        : json['chapterId'].toString();
    bookSlug = json['bookSlug'].toString() == 'null'
        ? ''
        : json['bookSlug'].toString();
    volume =
        json['volume'].toString() == 'null' ? '' : json['volume'].toString();
    book = json['book'] != null ? BookModel.fromJson(json['book']) : null;
    chapter =
        json['chapter'] != null ? ChapterModel.fromJson(json['chapter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hadithNumber'] = hadithNumber;
    data['englishNarrator'] = englishNarrator;
    data['hadithEnglish'] = hadithEnglish;
    data['hadithUrdu'] = hadithUrdu;
    data['urduNarrator'] = urduNarrator;
    data['hadithArabic'] = hadithArabic;
    data['chapterId'] = chapterId;
    data['bookSlug'] = bookSlug;
    data['volume'] = volume;
    if (book != null) {
      data['book'] = book!.toJson();
    }
    if (chapter != null) {
      data['chapter'] = chapter!.toJson();
    }
    return data;
  }
}
