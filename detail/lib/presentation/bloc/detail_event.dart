part of 'detail_bloc.dart';

@immutable
abstract class DetailEvent {
  const DetailEvent();
}

class OnLoadData extends DetailEvent {
  final int id;

  OnLoadData(this.id);
}
