part of 'popular_tv_list_bloc.dart';

@immutable
abstract class PopularTvSeriesListEvent extends Equatable {
  const PopularTvSeriesListEvent();

  @override
  List<Object> get props => [];
}

class OnLoadDataPopular extends PopularTvSeriesListEvent {}
