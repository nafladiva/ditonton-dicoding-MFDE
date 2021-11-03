import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/tvseries/get_season_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:detail/presentation/bloc/season_tvseries/season_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../dummy_data/dummy_objects.dart';
import 'season_tv_bloc_test.mocks.dart';

@GenerateMocks([GetSeasonDetail])
void main() {
  late SeasonTvBloc seasonTvBloc;
  late MockGetSeasonDetail mockGetSeasonDetail;

  setUp(() {
    mockGetSeasonDetail = MockGetSeasonDetail();
    seasonTvBloc = SeasonTvBloc(mockGetSeasonDetail);
  });

  test('initial state should be empty', () {
    expect(seasonTvBloc.state, SeasonEmpty());
  });

  blocTest<SeasonTvBloc, SeasonTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetSeasonDetail.execute(1, 1))
          .thenAnswer((_) async => Right(testSeasonDetail));
      return seasonTvBloc;
    },
    act: (bloc) => bloc.add(OnLoadData(1, 1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      SeasonLoading(),
      SeasonHasData(testSeasonDetail),
    ],
    verify: (bloc) {
      verify(mockGetSeasonDetail.execute(1, 1));
    },
  );

  blocTest<SeasonTvBloc, SeasonTvState>(
    'Should emit [Loading, Error] when get detail season is unsuccessful',
    build: () {
      when(mockGetSeasonDetail.execute(1, 1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seasonTvBloc;
    },
    act: (bloc) => bloc.add(OnLoadData(1, 1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      SeasonLoading(),
      SeasonError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetSeasonDetail.execute(1, 1));
    },
  );
}
