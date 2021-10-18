import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieDetailModel = MovieDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    budget: 1,
    genres: [],
    homepage: 'homepage',
    id: 1,
    imdbId: 'imdbId',
    originalLanguage: 'originalLanguage',
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    revenue: 1,
    runtime: 1,
    status: 'status',
    tagline: 'tagline',
    title: 'title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 1,
    title: 'title',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of Movie Detail entity', () async {
    final result = tMovieDetailModel.toEntity();
    expect(result, tMovieDetail);
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tMovieDetailModel.toJson();

      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": 'backdropPath',
        "budget": 1,
        "genres": [],
        "homepage": 'homepage',
        "id": 1,
        "imdb_id": 'imdbId',
        "original_language": 'originalLanguage',
        "original_title": 'originalTitle',
        "overview": 'overview',
        "popularity": 1.0,
        "poster_path": 'posterPath',
        "release_date": 'releaseDate',
        "revenue": 1,
        "runtime": 1,
        "status": 'status',
        "tagline": 'tagline',
        "title": 'title',
        "video": false,
        "vote_average": 1.0,
        "vote_count": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
