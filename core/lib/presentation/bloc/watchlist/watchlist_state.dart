part of 'watchlist_bloc.dart';

@immutable
abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistEmpty extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistError extends WatchlistState {
  final String message;

  WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistHasData extends WatchlistState {
  final List<Movie> result;
  final List<TvSeries> resultTv;

  WatchlistHasData(this.result, this.resultTv);

  @override
  List<Object> get props => [result, resultTv];
}
