part of 'popular_tv_bloc.dart';

@immutable
abstract class PopularTvEvent {
  const PopularTvEvent();
}

class OnLoadData extends PopularTvEvent {}
