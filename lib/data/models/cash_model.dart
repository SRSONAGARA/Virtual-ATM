class CashModel {
  final int? id;
  int? hundredRupeeNoteCount;
  int? twoHundredRupeeNoteCount;
  int? fiveHundredRupeeNoteCount;
  int? thousandRupeeNoteCount;
  int? twoThousandRupeeNoteCount;
  final DateTime? dateTime;

  CashModel(
      {this.id,
      this.hundredRupeeNoteCount,
      this.twoHundredRupeeNoteCount,
      this.fiveHundredRupeeNoteCount,
      this.thousandRupeeNoteCount,
      this.twoThousandRupeeNoteCount,
      this.dateTime});

  @override
  String toString() {
    return 'CashModel { '
        'id: $id, '
        'hundredRupeeNoteCount: $hundredRupeeNoteCount, '
        'twoHundredRupeeNoteCount: $twoHundredRupeeNoteCount, '
        'fiveHundredRupeeNoteCount: $fiveHundredRupeeNoteCount, '
        'thousandRupeeNoteCount: $thousandRupeeNoteCount, '
        'twoThousandRupeeNoteCount: $twoThousandRupeeNoteCount, '
        'dateTime: $dateTime '
        '}';
  }

  CashModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        hundredRupeeNoteCount = res['hundredRupeeNoteCount'],
        twoHundredRupeeNoteCount = res['twoHundredRupeeNoteCount'],
        fiveHundredRupeeNoteCount = res['fiveHundredRupeeNoteCount'],
        thousandRupeeNoteCount = res['thousandRupeeNoteCount'],
        twoThousandRupeeNoteCount = res['twoThousandRupeeNoteCount'],
        dateTime = res['dateTime'] != null ? DateTime.parse(res['dateTime']):null;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'hundredRupeeNoteCount': hundredRupeeNoteCount,
      'twoHundredRupeeNoteCount': twoHundredRupeeNoteCount,
      'fiveHundredRupeeNoteCount': fiveHundredRupeeNoteCount,
      'thousandRupeeNoteCount': thousandRupeeNoteCount,
      'twoThousandRupeeNoteCount': twoThousandRupeeNoteCount,
      'dateTime': dateTime?.toIso8601String(),
    };
  }
}
