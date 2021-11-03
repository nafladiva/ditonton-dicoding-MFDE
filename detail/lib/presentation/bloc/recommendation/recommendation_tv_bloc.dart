import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:core/domain/usecases/tvseries/get_tvseries_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'recommendation_tv_event.dart';
part 'recommendation_tv_state.dart';

class RecommendationTvBloc
    extends Bloc<RecommendationTvEvent, RecommendationTvState> {
  final GetTvSeriesRecommendations _tvSeriesRecommendations;

  RecommendationTvBloc(this._tvSeriesRecommendations)
      : super(RecommendationEmpty());

  @override
  Stream<RecommendationTvState> mapEventToState(
    RecommendationTvEvent event,
  ) async* {
    if (event is OnLoadDataRecom) {
      final tvSeriesId = event.id;

      yield RecommendationLoading();
      final result = await _tvSeriesRecommendations.execute(tvSeriesId);

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
