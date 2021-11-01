import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:core/domain/usecases/tvseries/get_watchlist_status_tv.dart';
import 'package:core/domain/usecases/tvseries/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/tvseries/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_status_tv_event.dart';
part 'watchlist_status_tv_state.dart';

class WatchlistStatusTvBloc
    extends Bloc<WatchlistStatusTvEvent, WatchlistStatusTvState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatusTvSeries _watchListStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  WatchlistStatusTvBloc(this._watchListStatusTvSeries,
      this.saveWatchlistTvSeries, this.removeWatchlistTvSeries)
      : super(WatchlistTvInitial());

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  @override
  Stream<WatchlistStatusTvState> mapEventToState(
    WatchlistStatusTvEvent event,
  ) async* {
    if (event is OnCurrentStatus) {
      final id = event.id;

      final isAdded = await _watchListStatusTvSeries.execute(id);
      yield UpdateWatchlist(isAdded);
    } else if (event is AddingWatchlist) {
      final tvSeries = event.tvSeries;

      final result = await saveWatchlistTvSeries.execute(tvSeries);

      yield* result.fold(
        (failure) async* {
          _watchlistMessage = failure.message;
        },
        (addedMessage) async* {
          _watchlistMessage = addedMessage;
          final isAdded = await _watchListStatusTvSeries.execute(tvSeries.id);
          yield UpdateWatchlist(isAdded);
        },
      );
    } else if (event is RemovingWatchlist) {
      final tvSeries = event.tvSeries;

      final result = await removeWatchlistTvSeries.execute(tvSeries);

      yield* result.fold(
        (failure) async* {
          _watchlistMessage = failure.message;
        },
        (removedMessage) async* {
          _watchlistMessage = removedMessage;
          final isAdded = await _watchListStatusTvSeries.execute(tvSeries.id);
          yield UpdateWatchlist(isAdded);
        },
      );
    }
  }
}
