abstract class CashWithdrawState {}

class CashWithdrawInitialState extends CashWithdrawState {}

class CashWithdrawSuccessState extends CashWithdrawState {}

class CashWithdrawErrorState extends CashWithdrawState {}

class HistoryFetchedSuccess extends CashWithdrawState {}

class HistoryFetchedError extends CashWithdrawState {}

class WithdrawHistorySuccess extends CashWithdrawState {}

class WithdrawHistoryError extends CashWithdrawState {}
