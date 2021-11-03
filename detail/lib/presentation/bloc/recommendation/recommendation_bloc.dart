import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'recommendation_event.dart';
part 'recommendation_state.dart';

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  final GetMovieRecommendations _movieRecommendations;

  RecommendationBloc(this._movieRecommendations) : super(RecommendationEmpty());

  @override
  Stream<RecommendationState> mapEventToState(
    RecommendationEvent event,
  ) async* {
    if (event is OnLoadDataRecom) {
      final movieId = event.id;

      yield RecommendationLoading();
      final result = await _movieRecommendations.execute(movieId);

      yield* result.fold(
        (failure) async* {
          yield RecommendationError(failure.message);
        },
        (data) async* {
          yield RecommendationHasData(data);
        },
      );
    }
  }
}
