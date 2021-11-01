import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:popular/domain/usecases/get_popular_movies.dart';

part 'popular_movie_list_event.dart';
part 'popular_movie_list_state.dart';

class PopularMovieListBloc
    extends Bloc<PopularMovieListEvent, PopularMovieListState> {
  final GetPopularMovies _popularMovies;

  PopularMovieListBloc(this._popularMovies) : super(PopularMovieListEmpty());

  @override
  Stream<PopularMovieListState> mapEventToState(
    PopularMovieListEvent event,
  ) async* {
    if (event is OnLoadDataPopular) {
      yield PopularMovieListLoading();

      final popular = await _popularMovies.execute();

      yield* popular.fold(
        (failure) async* {
          yield PopularMovieListError(failure.message);
        },
        (popularMovies) async* {
          yield PopularMovieListHasData(popularMovies);
        },
      );
    }
  }
}
