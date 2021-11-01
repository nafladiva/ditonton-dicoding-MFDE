part of 'top_rated_tv_list_bloc.dart';

@immutable
abstract class TopRatedTvSeriesListState extends Equatable {
  const TopRatedTvSeriesListState();

  @override
  List<Object> get props => [];
}

class TopRatedTvSeriesListInitial extends TopRatedTvSeriesListState {}

class TopRatedTvSeriesListEmpty extends TopRatedTvSeriesListState {}

class TopRatedTvSeriesListLoading extends TopRatedTvSeriesListState {}

class TopRatedTvSeriesListError extends TopRatedTvSeriesListState {
  final String message;

  TopRatedTvSeriesListError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTvSeriesListHasData extends TopRatedTvSeriesListState {
  final List<TvSeries> tvSeries;

  TopRatedTvSeriesListHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}
