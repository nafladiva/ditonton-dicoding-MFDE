part of 'popular_tv_list_bloc.dart';

@immutable
abstract class PopularTvSeriesListState extends Equatable {
  const PopularTvSeriesListState();

  @override
  List<Object> get props => [];
}

class PopularTvSeriesListInitial extends PopularTvSeriesListState {}

class PopularTvSeriesListEmpty extends PopularTvSeriesListState {}

class PopularTvSeriesListLoading extends PopularTvSeriesListState {}

class PopularTvSeriesListError extends PopularTvSeriesListState {
  final String message;

  PopularTvSeriesListError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTvSeriesListHasData extends PopularTvSeriesListState {
  final List<TvSeries> tvSeries;

  PopularTvSeriesListHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}
