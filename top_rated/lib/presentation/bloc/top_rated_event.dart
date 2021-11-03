part of 'top_rated_bloc.dart';

@immutable
abstract class TopRatedEvent {
  const TopRatedEvent();
}

class OnLoadData extends TopRatedEvent {}
