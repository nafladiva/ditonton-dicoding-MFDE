import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:core/domain/usecases/tvseries/get_now_playing_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'now_playing_tv_list_event.dart';
part 'now_playing_tv_list_state.dart';

class NowPlayingTvSeriesListBloc
    extends Bloc<NowPlayingTvSeriesListEvent, NowPlayingTvSeriesListState> {
  final GetNowPlayingTvSeries _nowPlayingTvSeries;

  NowPlayingTvSeriesListBloc(this._nowPlayingTvSeries)
      : super(NowPlayingTvSeriesListEmpty());

  @override
  Stream<NowPlayingTvSeriesListState> mapEventToState(
    NowPlayingTvSeriesListEvent event,
  ) async* {
    if (event is OnLoadDataNowPlaying) {
      yield NowPlayingTvSeriesListLoading();

      final nowPlaying = await _nowPlayingTvSeries.execute();

      yield* nowPlaying.fold(
        (failure) async* {
          yield NowPlayingTvSeriesListError(failure.message);
        },
        (nowPlayingTvSeries) async* {
          yield NowPlayingTvSeriesListHasData(nowPlayingTvSeries);
        },
      );
    }
  }
}
