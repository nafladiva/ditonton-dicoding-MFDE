import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toprated/domain/usecases/get_top_rated_tvseries.dart';

part 'top_rated_tv_list_event.dart';
part 'top_rated_tv_list_state.dart';

class TopRatedTvSeriesListBloc
    extends Bloc<TopRatedTvSeriesListEvent, TopRatedTvSeriesListState> {
  final GetTopRatedTvSeries _topRatedTvSeries;

  TopRatedTvSeriesListBloc(this._topRatedTvSeries)
      : super(TopRatedTvSeriesListEmpty());

  @override
  Stream<TopRatedTvSeriesListState> mapEventToState(
    TopRatedTvSeriesListEvent event,
  ) async* {
    if (event is OnLoadDataTopRated) {
      yield TopRatedTvSeriesListLoading();

      final topRated = await _topRatedTvSeries.execute();

      yield* topRated.fold(
        (failure) async* {
          yield TopRatedTvSeriesListError(failure.message);
        },
        (topRatedTvSeriess) async* {
          yield TopRatedTvSeriesListHasData(topRatedTvSeriess);
        },
      );
    }
  }
}
