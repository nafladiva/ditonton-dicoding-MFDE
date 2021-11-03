import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_status_event.dart';
part 'watchlist_status_state.dart';

class WatchlistStatusBloc
    extends Bloc<WatchlistStatusEvent, WatchlistStatusState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatus _watchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistStatusBloc(
      this._watchListStatus, this.saveWatchlist, this.removeWatchlist)
      : super(WatchlistInitial());

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  @override
  Stream<WatchlistStatusState> mapEventToState(
    WatchlistStatusEvent event,
  ) async* {
    if (event is OnCurrentStatus) {
      final id = event.id;

      final isAdded = await _watchListStatus.execute(id);
      yield UpdateWatchlist(isAdded);
    } else if (event is AddingWatchlist) {
      final movie = event.movie;

      final result = await saveWatchlist.execute(movie);

      yield* result.fold(
        (failure) async* {
          _watchlistMessage = failure.message;
        },
        (addedMessage) async* {
          _watchlistMessage = addedMessage;
          final isAdded = await _watchListStatus.execute(movie.id);
          yield UpdateWatchlist(isAdded);
        },
      );
    } else if (event is RemovingWatchlist) {
      final movie = event.movie;

      final result = await removeWatchlist.execute(movie);

      yield* result.fold(
        (failure) async* {
          _watchlistMessage = failure.message;
        },
        (removedMessage) async* {
          _watchlistMessage = removedMessage;
          final isAdded = await _watchListStatus.execute(movie.id);
          yield UpdateWatchlist(isAdded);
        },
      );
    }
  }
}
