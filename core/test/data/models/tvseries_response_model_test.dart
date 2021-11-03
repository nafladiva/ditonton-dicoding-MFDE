import 'dart:convert';

import 'package:core/data/models/tvseries_model.dart';
import 'package:core/data/models/tvseries_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: "/path.jpg",
    firstAirDate: "2006-09-18",
    genreIds: [1],
    id: 1,
    name: "Name",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "original",
    overview: "overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    voteAverage: 2.0,
    voteCount: 10,
  );

  final tTvSeriesResponseModel =
      TvSeriesResponse(tvseriesList: <TvSeriesModel>[tTvSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tvseries/now_playing.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "first_air_date": "2006-09-18",
            "genre_ids": [1],
            "id": 1,
            "name": "Name",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "original",
            "overview": "overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "vote_average": 2.0,
            "vote_count": 10
          }
        ],
      };

      expect(result, expectedJsonMap);
    });
  });
}
