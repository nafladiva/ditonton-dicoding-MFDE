part of 'now_playing_tv_list_bloc.dart';

@immutable
abstract class NowPlayingTvSeriesListState extends Equatable {
  const NowPlayingTvSeriesListState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvSeriesListInitial extends NowPlayingTvSeriesListState {}

class NowPlayingTvSeriesListEmpty extends NowPlayingTvSeriesListState {}

class NowPlayingTvSeriesListLoading extends NowPlayingTvSeriesListState {}

class NowPlayingTvSeriesListError extends NowPlayingTvSeriesListState {
  final String message;

  NowPlayingTvSeriesListError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingTvSeriesListHasData extends NowPlayingTvSeriesListState {
  final List<TvSeries> tvSeries;

  NowPlayingTvSeriesListHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}
