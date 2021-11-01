part of 'season_tv_bloc.dart';

@immutable
abstract class SeasonTvState extends Equatable {
  const SeasonTvState();

  @override
  List<Object> get props => [];
}

class SeasonTvInitial extends SeasonTvState {}

class SeasonEmpty extends SeasonTvState {}

class SeasonLoading extends SeasonTvState {}

class SeasonError extends SeasonTvState {
  final String message;

  SeasonError(this.message);

  @override
  List<Object> get props => [message];
}

class SeasonHasData extends SeasonTvState {
  final SeasonDetail result;

  SeasonHasData(this.result);

  @override
  List<Object> get props => [result];
}
