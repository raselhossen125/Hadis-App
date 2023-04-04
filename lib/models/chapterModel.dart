class ChapterModel {
  String? id;
  String? chapterNumber;
  String? chapterEnglish;
  String? chapterUrdu;
  String? chapterArabic;
  String? bookSlug;

  ChapterModel(
      {this.id,
      this.chapterNumber,
      this.chapterEnglish,
      this.chapterUrdu,
      this.chapterArabic,
      this.bookSlug});

  ChapterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null' ? '' : json['id'].toString();
    chapterNumber = json['chapterNumber'].toString() == 'null'
        ? ''
        : json['chapterNumber'].toString();
    chapterEnglish = json['chapterEnglish'].toString() == 'null'
        ? ''
        : json['chapterEnglish'].toString();
    chapterUrdu = json['chapterUrdu'].toString() == 'null'
        ? ''
        : json['chapterUrdu'].toString();
    chapterArabic = json['chapterArabic'].toString() == 'null'
        ? ''
        : json['chapterArabic'].toString();
    bookSlug = json['bookSlug'].toString() == 'null'
        ? ''
        : json['bookSlug'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chapterNumber'] = chapterNumber;
    data['chapterEnglish'] = chapterEnglish;
    data['chapterUrdu'] = chapterUrdu;
    data['chapterArabic'] = chapterArabic;
    data['bookSlug'] = bookSlug;
    return data;
  }
}
