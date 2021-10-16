import 'package:ditonton/data/models/tvseries_model.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 8.5,
    posterPath: 'posterPath',
    voteAverage: 8.5,
    voteCount: 20,
  );

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 8.5,
    posterPath: 'posterPath',
    voteAverage: 8.5,
    voteCount: 20,
  );

  test('should be a subclass of TvSeries entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}
