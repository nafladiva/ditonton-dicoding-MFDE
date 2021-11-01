import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:detail/domain/usecases/get_tvseries_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'detail_tv_event.dart';
part 'detail_tv_state.dart';

class DetailTvBloc extends Bloc<DetailTvEvent, DetailTvState> {
  final GetTvSeriesDetail _detailTvSeries;

  DetailTvBloc(this._detailTvSeries) : super(DetailEmpty());

  @override
  Stream<DetailTvState> mapEventToState(
    DetailTvEvent event,
  ) async* {
    if (event is OnLoadData) {
      final tvSeriesId = event.id;

      yield DetailLoading();
      final result = await _detailTvSeries.execute(tvSeriesId);

      yield* result.fold(
        (failure) async* {
          yield DetailError(failure.message);
        },
        (data) async* {
          yield DetailHasData(data);
        },
      );
    }
  }
}
