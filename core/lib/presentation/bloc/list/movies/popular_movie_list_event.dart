part of 'popular_movie_list_bloc.dart';

@immutable
abstract class PopularMovieListEvent extends Equatable {
  const PopularMovieListEvent();

  @override
  List<Object> get props => [];
}

class OnLoadDataPopular extends PopularMovieListEvent {}
