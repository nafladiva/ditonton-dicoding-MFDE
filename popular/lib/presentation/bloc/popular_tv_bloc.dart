import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:popular/domain/usecases/get_popular_tvseries.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTvSeries _popularTvSeries;

  PopularTvBloc(this._popularTvSeries) : super(PopularTvEmpty());

  @override
  Stream<PopularTvState> mapEventToState(
    PopularTvEvent event,
  ) async* {
    if (event is OnLoadData) {
      yield PopularTvLoading();
      final result = await _popularTvSeries.execute();

      yield* result.fold(
        (failure) async* {
          yield PopularTvError(failure.message);
        },
        (data) async* {
          yield PopularTvHasData(data);
        },
      );
    }
  }
}
