part of 'top_rated_movie_list_bloc.dart';

@immutable
abstract class TopRatedMovieListEvent extends Equatable {
  const TopRatedMovieListEvent();

  @override
  List<Object> get props => [];
}

class OnLoadDataTopRated extends TopRatedMovieListEvent {}
