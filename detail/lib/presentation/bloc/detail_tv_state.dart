part of 'detail_tv_bloc.dart';

@immutable
abstract class DetailTvState extends Equatable {
  const DetailTvState();

  @override
  List<Object> get props => [];
}

class DetailTvInitial extends DetailTvState {}

class DetailEmpty extends DetailTvState {}

class DetailLoading extends DetailTvState {}

class DetailError extends DetailTvState {
  final String message;

  DetailError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailHasData extends DetailTvState {
  final TvSeriesDetail result;

  DetailHasData(this.result);

  @override
  List<Object> get props => [result];
}
