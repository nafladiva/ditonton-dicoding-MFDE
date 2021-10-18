import 'package:ditonton/data/models/tvseries_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetail extends Equatable {
  TvSeriesDetail({
    required this.backdropPath,
    required this.genres,
    required this.seasons,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final List<Genre> genres;
  final List<Season> seasons;
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        seasons,
        id,
        name,
        overview,
        posterPath,
        firstAirDate,
        voteAverage,
        voteCount,
      ];
}
