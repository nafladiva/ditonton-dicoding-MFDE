part of 'popular_movie_list_bloc.dart';

@immutable
abstract class PopularMovieListState extends Equatable {
  const PopularMovieListState();

  @override
  List<Object> get props => [];
}

class PopularMovieListInitial extends PopularMovieListState {}

class PopularMovieListEmpty extends PopularMovieListState {}

class PopularMovieListLoading extends PopularMovieListState {}

class PopularMovieListError extends PopularMovieListState {
  final String message;

  PopularMovieListError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMovieListHasData extends PopularMovieListState {
  final List<Movie> movies;

  PopularMovieListHasData(this.movies);

  @override
  List<Object> get props => [movies];
}
