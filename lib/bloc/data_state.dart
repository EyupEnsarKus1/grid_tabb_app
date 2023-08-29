import '../model/data_model.dart';

abstract class DataState {}

class DataInitialState extends DataState {}

class DataLoadingState extends DataState {}

class DataLoadedState extends DataState {
  final List<DataModel> data;

  DataLoadedState(this.data);
}

class DataErrorState extends DataState {
  final String error;

  DataErrorState(this.error);
}
