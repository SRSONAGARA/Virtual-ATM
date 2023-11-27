abstract class CashInsertionState {}

class CashInsertionInitialState extends CashInsertionState {}

class ControllerValueEmptyState extends CashInsertionState {}

class DataInsertionSuccessState extends CashInsertionState {}

class DataInsertionErrorState extends CashInsertionState {}
