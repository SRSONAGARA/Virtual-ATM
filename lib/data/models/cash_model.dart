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

  @override
  String toString() {
    return 'CashModel { '
        'id: $id, '
        'hundredRupeeNoteCount: $hundredRupeeNoteCount, '
        'twoHundredRupeeNoteCount: $twoHundredRupeeNoteCount, '
        'fiveHundredRupeeNoteCount: $fiveHundredRupeeNoteCount, '
        'thousandRupeeNoteCount: $thousandRupeeNoteCount, '
        'twoThousandRupeeNoteCount: $twoThousandRupeeNoteCount '
        '}';
  }

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
