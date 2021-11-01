import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import '../../domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc(this._searchMovies) : super(SearchEmpty());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is OnQueryChanged) {
      final query = event.query;

      yield SearchLoading();
      final result = await _searchMovies.execute(query);

      yield* result.fold(
        (failure) async* {
          yield SearchError(failure.message);
        },
        (data) async* {
          yield SearchHasData(data);
        },
      );
    }
  }

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(transitionFn);
  }
}
