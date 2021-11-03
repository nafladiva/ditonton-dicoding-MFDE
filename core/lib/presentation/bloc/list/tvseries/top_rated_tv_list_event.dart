part of 'top_rated_tv_list_bloc.dart';

@immutable
abstract class TopRatedTvSeriesListEvent extends Equatable {
  const TopRatedTvSeriesListEvent();

  @override
  List<Object> get props => [];
}

class OnLoadDataTopRated extends TopRatedTvSeriesListEvent {}
