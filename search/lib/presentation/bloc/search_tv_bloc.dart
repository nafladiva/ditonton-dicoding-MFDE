import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:search/domain/usecases/search_tvseries.dart';
import 'package:rxdart/rxdart.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTvSeries _searchTvSeries;

  SearchTvBloc(this._searchTvSeries) : super(SearchTvEmpty());

  @override
  Stream<SearchTvState> mapEventToState(
    SearchTvEvent event,
  ) async* {
    if (event is OnQueryChanged) {
      final query = event.query;

      yield SearchTvLoading();
      final result = await _searchTvSeries.execute(query);

      yield* result.fold(
        (failure) async* {
          yield SearchTvError(failure.message);
        },
        (data) async* {
          yield SearchTvHasData(data);
        },
      );
    }
  }

  @override
  Stream<Transition<SearchTvEvent, SearchTvState>> transformEvents(
      Stream<SearchTvEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(transitionFn);
  }
}
