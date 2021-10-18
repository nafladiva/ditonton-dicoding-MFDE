import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tvseries_detail_model.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvSeriesDetailModel = TvSeriesDetailModel(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genres: [],
    homepage: 'homepage',
    id: 1,
    languages: [],
    name: 'name',
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    originCountry: [],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    seasons: [],
    status: 'status',
    tagline: 'tagline',
    type: 'type',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvSeriesDetail = TvSeriesDetail(
    backdropPath: 'backdropPath',
    genres: [],
    seasons: [],
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvSeriesDetailResponse = TvSeriesDetailModel(
      backdropPath: "/path.jpg",
      firstAirDate: "2017-05-02",
      genres: [GenreModel(id: 1, name: "Crime")],
      homepage: "https://www.netflix.com",
      id: 1,
      languages: ["es"],
      name: "Name",
      numberOfEpisodes: 3,
      numberOfSeasons: 1,
      originCountry: ["ES"],
      originalLanguage: "es",
      originalName: "Original",
      overview: "overview",
      popularity: 80,
      posterPath: "/path.jpg",
      seasons: [],
      status: "Returning Series",
      tagline: "Tagline",
      type: "Scripted",
      voteAverage: 1.0,
      voteCount: 100);

  final tTvSeriesSeasonResponse = Season(
    airDate: "2019-01-11",
    episodeCount: 8,
    id: 107288,
    name: "Season 1",
    overview: "",
    posterPath: "/u3eoZguH2tqLLKqRqWjvisF0d2U.jpg",
    seasonNumber: 1,
  );

  test('TvSeries Detail should be a subclass of Tv series Detail entity',
      () async {
    final result = tTvSeriesDetailModel.toEntity();
    expect(result, tTvSeriesDetail);
  });

  group('TvSeries Detail fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tvseries/tvseries_detail.json'));
      // act
      final result = TvSeriesDetailModel.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesDetailResponse);
    });
  });

  group('TvSeries Detail toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvSeriesDetailModel.toJson();

      final expectedJsonMap = {
        "backdrop_path": 'backdropPath',
        "first_air_date": 'firstAirDate',
        "genres": [],
        "homepage": 'homepage',
        "id": 1,
        "languages": [],
        "name": 'name',
        "number_of_episodes": 1,
        "number_of_seasons": 1,
        "origin_country": [],
        "original_language": 'originalLanguage',
        "original_name": 'originalName',
        "overview": 'overview',
        "popularity": 1.0,
        "poster_path": 'posterPath',
        "seasons": [],
        "status": 'status',
        "tagline": 'tagline',
        "type": 'type',
        "vote_average": 1.0,
        "vote_count": 1,
      };

      expect(result, expectedJsonMap);
    });
  });

  group('Season fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tvseries/tvseries_season.json'));
      // act
      final result = Season.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesSeasonResponse);
    });
  });

  group('Season toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvSeriesSeasonResponse.toJson();

      final expectedJsonMap = {
        "air_date": "2019-01-11",
        "episode_count": 8,
        "id": 107288,
        "name": "Season 1",
        "overview": "",
        "poster_path": "/u3eoZguH2tqLLKqRqWjvisF0d2U.jpg",
        "season_number": 1,
      };

      expect(result, expectedJsonMap);
    });
  });

  test('TvSeries Season should be a subclass of Tv series Season entity',
      () async {
    final result = tTvSeriesSeasonResponse.toEntity();
    expect(result, tTvSeriesSeasonResponse);
  });
}
