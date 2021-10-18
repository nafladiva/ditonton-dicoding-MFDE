import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tMovieTable.toJson();

      final expectedJsonMap = {
        "id": 1,
        "title": 'title',
        "posterPath": 'posterPath',
        "overview": 'overview',
      };

      expect(result, expectedJsonMap);
    });
  });
}
