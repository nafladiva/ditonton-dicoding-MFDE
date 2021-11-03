part of 'popular_bloc.dart';

@immutable
abstract class PopularEvent {
  const PopularEvent();
}

class OnLoadData extends PopularEvent {}
