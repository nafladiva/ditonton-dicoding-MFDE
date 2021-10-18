import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';

class GetSeasonDetail {
  final TvSeriesRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int id, int season) {
    return repository.getSeasonDetail(id, season);
  }
}
