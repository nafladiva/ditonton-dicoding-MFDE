part of 'detail_bloc.dart';

@immutable
abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class DetailEmpty extends DetailState {}

class DetailLoading extends DetailState {}

class DetailError extends DetailState {
  final String message;

  DetailError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailHasData extends DetailState {
  final MovieDetail result;

  DetailHasData(this.result);

  @override
  List<Object> get props => [result];
}
