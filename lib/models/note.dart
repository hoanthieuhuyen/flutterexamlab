class Note {
  int iId;
  String sTitle;
  String sDescription;
  String sDate;
  int iPriority;

  Note(
      {required this.iId,
      required this.sTitle,
      required this.sDescription,
      required this.sDate,
      required this.iPriority});

  Note.withId(
      this.iId, this.sTitle, this.sDate, this.iPriority, this.sDescription);

  int get id => iId;

  String get title => sTitle;

  String get description => sDescription;

  int get priority => iPriority;

  String get date => sDate;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      sTitle = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      sDescription = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      iPriority = newPriority;
    }
  }

  set date(String newDate) {
    sDate = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = iId;
    }
    map['title'] = sTitle;
    map['description'] = sDescription;
    map['priority'] = iPriority;
    map['date'] = sDate;

    return map;
  }

  factory Note.fromJson(Map<String, dynamic> responseData) {
    return Note(
      iId: responseData['iId'],
      sTitle: responseData['sTitle'],
      sDescription: responseData['sDescription'],
      sDate: responseData['sDate'],
      iPriority: responseData['iPriority'],
    );
  }
}
