import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'now_playing_movie_list_event.dart';
part 'now_playing_movie_list_state.dart';

class NowPlayingMovieListBloc
    extends Bloc<NowPlayingMovieListEvent, NowPlayingMovieListState> {
  final GetNowPlayingMovies _nowPlayingMovies;

  NowPlayingMovieListBloc(this._nowPlayingMovies)
      : super(NowPlayingMovieListEmpty());

  @override
  Stream<NowPlayingMovieListState> mapEventToState(
    NowPlayingMovieListEvent event,
  ) async* {
    if (event is OnLoadDataNowPlaying) {
      yield NowPlayingMovieListLoading();

      final nowPlaying = await _nowPlayingMovies.execute();

      yield* nowPlaying.fold(
        (failure) async* {
          yield NowPlayingMovieListError(failure.message);
        },
        (nowPlayingMovies) async* {
          yield NowPlayingMovieListHasData(nowPlayingMovies);
        },
      );
    }
  }
}
