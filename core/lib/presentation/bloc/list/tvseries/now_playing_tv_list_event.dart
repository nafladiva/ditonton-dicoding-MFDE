part of 'now_playing_tv_list_bloc.dart';

@immutable
abstract class NowPlayingTvSeriesListEvent extends Equatable {
  const NowPlayingTvSeriesListEvent();

  @override
  List<Object> get props => [];
}

class OnLoadDataNowPlaying extends NowPlayingTvSeriesListEvent {}
