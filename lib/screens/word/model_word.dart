class NewWord {
  int? iId;
  String sEnglish;
  String sVietnamese;
  int iStatus;

  NewWord(
      {required this.iId,
      required this.sEnglish,
      required this.sVietnamese,
      required this.iStatus});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = iId;
    map['english'] = sEnglish;
    map['vietnamese'] = sVietnamese;
    map['status'] = iStatus;
    return map;
  }

  factory NewWord.fromJson(Map<String, dynamic> responseData) {
    return NewWord(
      iId: responseData['iId'],
      sEnglish: responseData['sEnglish'],
      sVietnamese: responseData['sVietnamese'],
      iStatus: responseData['iStatus'],
    );
  }
}
