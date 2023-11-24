class CashModel {
  final int? id;
  final int? hundredRupeeNoteCount;
  final int? twoHundredRupeeNoteCount;
  final int? fiveHundredRupeeNoteCount;
  final int? thousandRupeeNoteCount;
  final int? twoThousandRupeeNoteCount;

  CashModel(
      {this.id,
      this.hundredRupeeNoteCount,
      this.twoHundredRupeeNoteCount,
      this.fiveHundredRupeeNoteCount,
      this.thousandRupeeNoteCount,
      this.twoThousandRupeeNoteCount});

  CashModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        hundredRupeeNoteCount = res['hundredRupeeNoteCount'],
        twoHundredRupeeNoteCount = res['twoHundredRupeeNoteCount'],
        fiveHundredRupeeNoteCount = res['fiveHundredRupeeNoteCount'],
        thousandRupeeNoteCount = res['thousandRupeeNoteCount'],
        twoThousandRupeeNoteCount = res['twoThousandRupeeNoteCount'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'hundredRupeeNoteCount': hundredRupeeNoteCount,
      'twoHundredRupeeNoteCount': twoHundredRupeeNoteCount,
      'fiveHundredRupeeNoteCount': fiveHundredRupeeNoteCount,
      'thousandRupeeNoteCount': thousandRupeeNoteCount,
      'twoThousandRupeeNoteCount': twoThousandRupeeNoteCount
    };
  }
}

/*class NotesModel {
  late int _id;
  late int _hundredRupeeNoteCount;
  late int _twoHundredRupeeNoteCount;
  late int _fiveHundredRupeeNoteCount;
  late int _thousandRupeeNoteCount;
  late int _twoThousandRupeeNoteCount;

  NotesModel.withId(
      this._id,
      this._hundredRupeeNoteCount,
      this._twoHundredRupeeNoteCount,
      this._fiveHundredRupeeNoteCount,
      this._thousandRupeeNoteCount,
      this._twoThousandRupeeNoteCount);

  int get id => _id;
  int get hundredRupeeNoteCount => _hundredRupeeNoteCount;
  int get twoHundredRupeeNoteCount => _twoHundredRupeeNoteCount;
  int get fiveHundredRupeeNoteCount => _fiveHundredRupeeNoteCount;
  int get thousandRupeeNoteCount => _thousandRupeeNoteCount;
  int get twoThousandRupeeNoteCount => _twoThousandRupeeNoteCount;

  set hundredRupeeNoteCount(int newHundredRupeeNoteCount) {
    this._hundredRupeeNoteCount = newHundredRupeeNoteCount;
  }

  set twoHundredRupeeNoteCount(int newTwoHundredRupeeNoteCount) {
    this._twoHundredRupeeNoteCount = newTwoHundredRupeeNoteCount;
  }

  set fiveHundredRupeeNoteCount(int newFiveHundredRupeeNoteCount) {
    this._fiveHundredRupeeNoteCount = newFiveHundredRupeeNoteCount;
  }

  set thousandRupeeNoteCount(int newThousandRupeeNoteCount) {
    this._thousandRupeeNoteCount = newThousandRupeeNoteCount;
  }

  set twoThousandRupeeNoteCount(int newTwoThousandRupeeNoteCount) {
    this._twoThousandRupeeNoteCount = newTwoThousandRupeeNoteCount;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['hundredRupeeNoteCount'] = _hundredRupeeNoteCount;
    map['twoHundredRupeeNoteCount'] = _twoHundredRupeeNoteCount;
    map['fiveHundredRupeeNoteCount'] = _fiveHundredRupeeNoteCount;
    map['thousandRupeeNoteCount'] = _thousandRupeeNoteCount;
    map['twoThousandRupeeNoteCount'] = _twoThousandRupeeNoteCount;

    return map;
  }

  NotesModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._hundredRupeeNoteCount = map['hundredRupeeNoteCount'];
    this._twoHundredRupeeNoteCount = map['twoHundredRupeeNoteCount'];
    this._fiveHundredRupeeNoteCount = map['fiveHundredRupeeNoteCount'];
    this._thousandRupeeNoteCount = map['thousandRupeeNoteCount'];
    this._twoThousandRupeeNoteCount = map['twoThousandRupeeNoteCount'];
  }
}*/
