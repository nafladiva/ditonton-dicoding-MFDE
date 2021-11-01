part of 'top_rated_tv_bloc.dart';

@immutable
abstract class TopRatedTvEvent {
  const TopRatedTvEvent();
}

class OnLoadData extends TopRatedTvEvent {}
