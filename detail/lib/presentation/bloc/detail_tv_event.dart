part of 'detail_tv_bloc.dart';

@immutable
abstract class DetailTvEvent {
  const DetailTvEvent();
}

class OnLoadData extends DetailTvEvent {
  final int id;

  OnLoadData(this.id);
}
