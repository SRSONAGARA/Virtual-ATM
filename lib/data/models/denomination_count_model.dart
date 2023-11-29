class DenominationCountModel {
  final int? id;
  int? hundredRupeeTotalNoteCount;
  int? twoHundredRupeeTotalNoteCount;
  int? fiveHundredRupeeTotalNoteCount;
  int? thousandRupeeTotalNoteCount;
  int? twoThousandRupeeTotalNoteCount;

  DenominationCountModel(
      {this.id,
      this.hundredRupeeTotalNoteCount,
      this.twoHundredRupeeTotalNoteCount,
      this.fiveHundredRupeeTotalNoteCount,
      this.thousandRupeeTotalNoteCount,
      this.twoThousandRupeeTotalNoteCount});

  @override
  String toString() {
    return 'DenominationCountModel { '
        'id: $id,'
        'hundredRupeeTotalNoteCount: $hundredRupeeTotalNoteCount, '
        'twoHundredRupeeTotalNoteCount: $twoHundredRupeeTotalNoteCount, '
        'fiveHundredRupeeTotalNoteCount: $fiveHundredRupeeTotalNoteCount, '
        'thousandRupeeTotalNoteCount: $thousandRupeeTotalNoteCount, '
        'twoThousandRupeeTotalNoteCount: $twoThousandRupeeTotalNoteCount, '
        '}';
  }

  DenominationCountModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        hundredRupeeTotalNoteCount = res['hundredRupeeTotalNoteCount'],
        twoHundredRupeeTotalNoteCount = res['twoHundredRupeeTotalNoteCount'],
        fiveHundredRupeeTotalNoteCount = res['fiveHundredRupeeTotalNoteCount'],
        thousandRupeeTotalNoteCount = res['thousandRupeeTotalNoteCount'],
        twoThousandRupeeTotalNoteCount = res['twoThousandRupeeTotalNoteCount'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'hundredRupeeTotalNoteCount': hundredRupeeTotalNoteCount,
      'twoHundredRupeeTotalNoteCount': twoHundredRupeeTotalNoteCount,
      'fiveHundredRupeeTotalNoteCount': fiveHundredRupeeTotalNoteCount,
      'thousandRupeeTotalNoteCount': thousandRupeeTotalNoteCount,
      'twoThousandRupeeTotalNoteCount': twoThousandRupeeTotalNoteCount,
    };
  }
}
