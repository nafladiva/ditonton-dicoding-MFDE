import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:popular/domain/usecases/get_popular_tvseries.dart';

part 'popular_tv_list_event.dart';
part 'popular_tv_list_state.dart';

class PopularTvSeriesListBloc
    extends Bloc<PopularTvSeriesListEvent, PopularTvSeriesListState> {
  final GetPopularTvSeries _popularTvSeries;

  PopularTvSeriesListBloc(this._popularTvSeries)
      : super(PopularTvSeriesListEmpty());

  @override
  Stream<PopularTvSeriesListState> mapEventToState(
    PopularTvSeriesListEvent event,
  ) async* {
    if (event is OnLoadDataPopular) {
      yield PopularTvSeriesListLoading();

      final popular = await _popularTvSeries.execute();

      yield* popular.fold(
        (failure) async* {
          yield PopularTvSeriesListError(failure.message);
        },
        (popularTvSeries) async* {
          yield PopularTvSeriesListHasData(popularTvSeries);
        },
      );
    }
  }
}
