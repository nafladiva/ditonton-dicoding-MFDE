import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvseries/get_season_detail.dart';
import 'package:ditonton/presentation/provider/tvseries/season_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'season_detail_notifier_test.mocks.dart';

@GenerateMocks([GetSeasonDetail])
void main() {
  late SeasonDetailNotifier provider;
  late MockGetSeasonDetail mockGetSeasonDetail;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetSeasonDetail = MockGetSeasonDetail();
    provider = SeasonDetailNotifier(getSeasonDetail: mockGetSeasonDetail)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvId = 1;
  final tSeasonNum = 1;

  void _arrangeUsecase() {
    when(mockGetSeasonDetail.execute(tTvId, tSeasonNum))
        .thenAnswer((_) async => Right(testSeasonDetail));
  }

  group('Get Tv series Season Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tTvId, tSeasonNum);
      // assert
      verify(mockGetSeasonDetail.execute(tTvId, tSeasonNum));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchSeasonDetail(tTvId, tSeasonNum);
      // assert
      expect(provider.seasonState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change season when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tTvId, tSeasonNum);
      // assert
      expect(provider.seasonState, RequestState.Loaded);
      expect(provider.season, testSeasonDetail);
      expect(listenerCallCount, 3);
    });

    test('should update season message when get season detail failed',
        () async {
      // arrange
      when(mockGetSeasonDetail.execute(tTvId, tSeasonNum))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      // act
      await provider.fetchSeasonDetail(tTvId, tSeasonNum);
      // assert
      expect(provider.message, 'Failed');
      expect(listenerCallCount, 2);
    });
  });
}
