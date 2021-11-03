part of 'now_playing_movie_list_bloc.dart';

@immutable
abstract class NowPlayingMovieListState extends Equatable {
  const NowPlayingMovieListState();

  @override
  List<Object> get props => [];
}

class NowPlayingMovieListInitial extends NowPlayingMovieListState {}

class NowPlayingMovieListEmpty extends NowPlayingMovieListState {}

class NowPlayingMovieListLoading extends NowPlayingMovieListState {}

class NowPlayingMovieListError extends NowPlayingMovieListState {
  final String message;

  NowPlayingMovieListError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingMovieListHasData extends NowPlayingMovieListState {
  final List<Movie> movies;

  NowPlayingMovieListHasData(this.movies);

  @override
  List<Object> get props => [movies];
}
