part of 'recommendation_bloc.dart';

@immutable
abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object> get props => [];
}

class RecommendationInitial extends RecommendationState {}

class RecommendationEmpty extends RecommendationState {}

class RecommendationLoading extends RecommendationState {}

class RecommendationError extends RecommendationState {
  final String message;

  RecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationHasData extends RecommendationState {
  final List<Movie> recommendations;

  RecommendationHasData(this.recommendations);

  @override
  List<Object> get props => [recommendations];
}
