import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_tabb_app/bloc/data_event.dart';
import 'package:grid_tabb_app/bloc/data_state.dart';

import '../model/data_model.dart';
import '../repository/repository.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataRepository dataRepository;

  DataBloc(this.dataRepository) : super(DataInitialState()) {
    on<FetchDataEvent>(_onLoadData);
  }

  _onLoadData(FetchDataEvent event, Emitter<DataState> emitter) async {
    try {
      emitter(DataLoadingState());
      final List<DataModel> data = await dataRepository.fetchData();
      emitter(DataLoadedState(data));
    } catch (e) {
      emitter(DataErrorState(e.toString()));
    }
  }
}
