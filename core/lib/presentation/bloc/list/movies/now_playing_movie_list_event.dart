part of 'now_playing_movie_list_bloc.dart';

@immutable
abstract class NowPlayingMovieListEvent extends Equatable {
  const NowPlayingMovieListEvent();

  @override
  List<Object> get props => [];
}

class OnLoadDataNowPlaying extends NowPlayingMovieListEvent {}
