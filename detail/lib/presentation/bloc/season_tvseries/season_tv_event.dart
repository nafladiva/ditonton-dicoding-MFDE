part of 'season_tv_bloc.dart';

@immutable
abstract class SeasonTvEvent {
  const SeasonTvEvent();
}

class OnLoadData extends SeasonTvEvent {
  final int tvId;
  final int seasonNum;

  OnLoadData(this.tvId, this.seasonNum);
}
