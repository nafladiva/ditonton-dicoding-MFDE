part of 'watchlist_status_tv_bloc.dart';

@immutable
abstract class WatchlistStatusTvEvent {
  const WatchlistStatusTvEvent();
}

class OnCurrentStatus extends WatchlistStatusTvEvent {
  final int id;

  OnCurrentStatus(this.id);
}

class AddingWatchlist extends WatchlistStatusTvEvent {
  final TvSeriesDetail tvSeries;

  AddingWatchlist(this.tvSeries);
}

class RemovingWatchlist extends WatchlistStatusTvEvent {
  final TvSeriesDetail tvSeries;

  RemovingWatchlist(this.tvSeries);
}
