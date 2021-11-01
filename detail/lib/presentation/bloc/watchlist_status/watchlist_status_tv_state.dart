part of 'watchlist_status_tv_bloc.dart';

@immutable
abstract class WatchlistStatusTvState extends Equatable {
  const WatchlistStatusTvState();

  @override
  List<Object> get props => [];
}

class WatchlistTvInitial extends WatchlistStatusTvState {}

class UpdateWatchlist extends WatchlistStatusTvState {
  final bool isAdded;

  UpdateWatchlist(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}
