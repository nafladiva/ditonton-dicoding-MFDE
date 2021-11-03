part of 'watchlist_status_bloc.dart';

@immutable
abstract class WatchlistStatusEvent {
  const WatchlistStatusEvent();
}

class OnCurrentStatus extends WatchlistStatusEvent {
  final int id;

  OnCurrentStatus(this.id);
}

class AddingWatchlist extends WatchlistStatusEvent {
  final MovieDetail movie;

  AddingWatchlist(this.movie);
}

class RemovingWatchlist extends WatchlistStatusEvent {
  final MovieDetail movie;

  RemovingWatchlist(this.movie);
}
