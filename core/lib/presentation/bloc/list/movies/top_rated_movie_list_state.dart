part of 'top_rated_movie_list_bloc.dart';

@immutable
abstract class TopRatedMovieListState extends Equatable {
  const TopRatedMovieListState();

  @override
  List<Object> get props => [];
}

class TopRatedMovieListInitial extends TopRatedMovieListState {}

class TopRatedMovieListEmpty extends TopRatedMovieListState {}

class TopRatedMovieListLoading extends TopRatedMovieListState {}

class TopRatedMovieListError extends TopRatedMovieListState {
  final String message;

  TopRatedMovieListError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedMovieListHasData extends TopRatedMovieListState {
  final List<Movie> movies;

  TopRatedMovieListHasData(this.movies);

  @override
  List<Object> get props => [movies];
}
