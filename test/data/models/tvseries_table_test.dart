import 'package:ditonton/data/models/tvseries_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    name: "name",
    posterPath: "posterPath",
    overview: "overview",
  );

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvSeriesTable.toJson();

      final expectedJsonMap = {
        "id": 1,
        "name": "name",
        "posterPath": 'posterPath',
        "overview": 'overview',
      };

      expect(result, expectedJsonMap);
    });
  });
}
