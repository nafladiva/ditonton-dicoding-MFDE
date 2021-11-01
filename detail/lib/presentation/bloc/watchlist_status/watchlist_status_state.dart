part of 'watchlist_status_bloc.dart';

@immutable
abstract class WatchlistStatusState extends Equatable {
  const WatchlistStatusState();

  @override
  List<Object> get props => [];
}

class WatchlistInitial extends WatchlistStatusState {}

class UpdateWatchlist extends WatchlistStatusState {
  final bool isAdded;

  UpdateWatchlist(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}
