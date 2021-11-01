part of 'recommendation_bloc.dart';

@immutable
abstract class RecommendationEvent {
  const RecommendationEvent();
}

class OnLoadDataRecom extends RecommendationEvent {
  final int id;

  OnLoadDataRecom(this.id);
}
