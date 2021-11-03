import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toprated/domain/usecases/get_top_rated_tvseries.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTvSeries _topRatedTvSeries;

  TopRatedTvBloc(this._topRatedTvSeries) : super(TopRatedTvEmpty());

  @override
  Stream<TopRatedTvState> mapEventToState(
    TopRatedTvEvent event,
  ) async* {
    if (event is OnLoadData) {
      yield TopRatedTvLoading();
      final result = await _topRatedTvSeries.execute();

      yield* result.fold(
        (failure) async* {
          yield TopRatedTvError(failure.message);
        },
        (data) async* {
          yield TopRatedTvHasData(data);
        },
      );
    }
  }
}
