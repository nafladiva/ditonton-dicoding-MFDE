import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:core/domain/repositories/tvseries_repository.dart';

class GetSeasonDetail {
  final TvSeriesRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int id, int season) {
    return repository.getSeasonDetail(id, season);
  }
}
