part of 'recommendation_tv_bloc.dart';

@immutable
abstract class RecommendationTvEvent {
  const RecommendationTvEvent();
}

class OnLoadDataRecom extends RecommendationTvEvent {
  final int id;

  OnLoadDataRecom(this.id);
}
