import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tvseries/get_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeasonDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetSeasonDetail(mockTvSeriesRepository);
  });

  final tTvId = 1;
  final tSeasonNum = 1;

  test('should get tv series season detail from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getSeasonDetail(tTvId, tSeasonNum))
        .thenAnswer((_) async => Right(testSeasonDetail));
    // act
    final result = await usecase.execute(tTvId, tSeasonNum);
    // assert
    expect(result, Right(testSeasonDetail));
  });
}
