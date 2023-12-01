class WithdrawHistoryModel {
  final int? id;
  int withdrawnAmount;
  final DateTime? dateTime;

  WithdrawHistoryModel({this.id, required this.withdrawnAmount, this.dateTime});

  @override
  String toString() {
    return 'WithdrawHistoryModel { '
        'id: $id, '
        'withdrawnAmount: $withdrawnAmount, '
        'dateTime: $dateTime '
        '}';
  }

  WithdrawHistoryModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        withdrawnAmount = res['withdrawnAmount'],
        dateTime =
            res['dateTime'] != null ? DateTime.parse(res['dateTime']) : null;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'withdrawnAmount': withdrawnAmount,
      'dateTime': dateTime?.toIso8601String(),
    };
  }
}
