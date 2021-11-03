import 'dart:convert';

import 'package:core/data/models/season_model.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tSeasonDetailModel = SeasonModel(
    id: 'id',
    airDate: 'airDate',
    episodes: [],
    name: 'name',
    overview: 'overview',
    seasonModelId: 1,
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  final tSeasonDetail = SeasonDetail(
    id: 'id',
    airDate: 'airDate',
    episodes: [],
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  final tSeasonDetailResponse = SeasonModel(
    id: "5f3b23f566e46900354ac0a5",
    airDate: "2020-09-13",
    episodes: [],
    name: "Season 1",
    overview: "",
    seasonModelId: 159392,
    posterPath: "/2UuRWSoLCTohtKOTpKI1lwL5GrD.jpg",
    seasonNumber: 1,
  );

  final tEpisodeDetailResponse = Episode(
    airDate: "2020-09-14",
    episodeNumber: 1,
    id: 2392727,
    name: "Episode 1",
    overview: '',
    productionCode: '',
    seasonNumber: 1,
    stillPath: "/d5dVLqGdRtthkiMoJPCuctAKrBX.jpg",
    voteAverage: 0,
    voteCount: 0,
  );

  test('should be a subclass of Tv series Season Detail entity', () async {
    final result = tSeasonDetailModel.toEntity();
    expect(result, tSeasonDetail);
  });

  group('SeasonDetail fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tvseries/season.json'));
      // act
      final result = SeasonModel.fromJson(jsonMap);
      // assert
      expect(result, tSeasonDetailResponse);
    });
  });

  group('SeasonDetail toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tSeasonDetailModel.toJson();
      // assert
      final expectedJsonMap = {
        "_id": "id",
        "air_date": "airDate",
        "episodes": [],
        "name": "name",
        "overview": "overview",
        "id": 1,
        "poster_path": "posterPath",
        "season_number": 1
      };
      expect(result, expectedJsonMap);
    });
  });

  group('Episode fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tvseries/episode.json'));
      // act
      final result = Episode.fromJson(jsonMap);
      // assert
      expect(result, tEpisodeDetailResponse);
    });
  });

  group('Episode toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tEpisodeDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        "air_date": "2020-09-14",
        "episode_number": 1,
        "id": 2392727,
        "name": "Episode 1",
        "overview": '',
        "production_code": '',
        "season_number": 1,
        "still_path": "/d5dVLqGdRtthkiMoJPCuctAKrBX.jpg",
        "vote_average": 0,
        "vote_count": 0,
      };

      expect(result, expectedJsonMap);
    });
  });
}
