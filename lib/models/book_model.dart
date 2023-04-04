class BookModel {
  String? id;
  String? bookName;
  String? writerName;
  String? aboutWriter;
  String? writerDeath;
  String? bookSlug;
  String? hadithsCount;
  String? chaptersCount;

  BookModel(
      {this.id,
      this.bookName,
      this.writerName,
      this.aboutWriter,
      this.writerDeath,
      this.bookSlug,
      this.hadithsCount,
      this.chaptersCount});

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null' ? '' : json['id'].toString();
    bookName = json['bookName'].toString() == 'null'
        ? ''
        : json['bookName'].toString();
    writerName = json['writerName'].toString() == 'null'
        ? ''
        : json['writerName'].toString();
    aboutWriter = json['aboutWriter'].toString() == 'null'
        ? ''
        : json['aboutWriter'].toString();
    writerDeath = json['writerDeath'].toString() == 'null'
        ? ''
        : json['writerDeath'].toString();
    bookSlug = json['bookSlug'].toString() == 'null'
        ? ''
        : json['bookSlug'].toString();
    hadithsCount = json['hadiths_count'].toString() == 'null'
        ? ''
        : json['hadiths_count'].toString();
    chaptersCount = json['chapters_count'].toString() == 'null'
        ? ''
        : json['chapters_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookName'] = bookName;
    data['writerName'] = writerName;
    data['aboutWriter'] = aboutWriter;
    data['writerDeath'] = writerDeath;
    data['bookSlug'] = bookSlug;
    data['hadiths_count'] = hadithsCount;
    data['chapters_count'] = chaptersCount;
    return data;
  }
}
