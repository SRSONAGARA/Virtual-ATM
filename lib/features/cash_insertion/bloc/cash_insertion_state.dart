abstract class CashInsertionState {}

class CashInsertionInitialState extends CashInsertionState {}

class ControllerValueEmptyState extends CashInsertionState {}

class DataInsertedSuccessState extends CashInsertionState {}

class DataInsertedErrorState extends CashInsertionState {}
