import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/tvseries/get_watchlist_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies _watchlistMovies;
  final GetWatchlistTvSeries _watchlistTvSeries;

  WatchlistBloc(this._watchlistMovies, this._watchlistTvSeries)
      : super(WatchlistEmpty());

  @override
  Stream<WatchlistState> mapEventToState(
    WatchlistEvent event,
  ) async* {
    if (event is OnLoadData) {
      yield WatchlistLoading();
      final result = await _watchlistMovies.execute();
      final resultTv = await _watchlistTvSeries.execute();

      yield* result.fold(
        (failure) async* {
          yield WatchlistError(failure.message);
        },
        (data) async* {
          yield* resultTv.fold((failure) async* {
            yield WatchlistError(failure.message);
          }, (dataTv) async* {
            yield WatchlistHasData(data, dataTv);
          });
        },
      );
    }
  }
}
