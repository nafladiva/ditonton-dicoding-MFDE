import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:core/domain/usecases/tvseries/get_season_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'season_tv_event.dart';
part 'season_tv_state.dart';

class SeasonTvBloc extends Bloc<SeasonTvEvent, SeasonTvState> {
  final GetSeasonDetail _seasonDetail;

  SeasonTvBloc(this._seasonDetail) : super(SeasonEmpty());

  @override
  Stream<SeasonTvState> mapEventToState(
    SeasonTvEvent event,
  ) async* {
    if (event is OnLoadData) {
      final tvId = event.tvId;
      final seasonNum = event.seasonNum;

      yield SeasonLoading();
      final result = await _seasonDetail.execute(tvId, seasonNum);

      yield* result.fold(
        (failure) async* {
          yield SeasonError(failure.message);
        },
        (data) async* {
          yield SeasonHasData(data);
        },
      );
    }
  }
}
