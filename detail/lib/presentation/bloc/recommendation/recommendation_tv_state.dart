part of 'recommendation_tv_bloc.dart';

@immutable
abstract class RecommendationTvState extends Equatable {
  const RecommendationTvState();

  @override
  List<Object> get props => [];
}

class RecommendationTvInitial extends RecommendationTvState {}

class RecommendationEmpty extends RecommendationTvState {}

class RecommendationLoading extends RecommendationTvState {}

class RecommendationError extends RecommendationTvState {
  final String message;

  RecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationHasData extends RecommendationTvState {
  final List<TvSeries> recommendations;

  RecommendationHasData(this.recommendations);

  @override
  List<Object> get props => [recommendations];
}
