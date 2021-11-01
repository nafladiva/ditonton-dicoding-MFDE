import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:core/domain/usecases/tvseries/get_tvseries_recommendations.dart';
import 'package:core/utils/failure.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'recommendation_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendations])
void main() {
  late RecommendationTvBloc recommendationTvBloc;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  final tTvSeriesList = <TvSeries>[testTvSeries];

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    recommendationTvBloc = RecommendationTvBloc(mockGetTvSeriesRecommendations);
  });

  test('initial state should be empty', () {
    expect(recommendationTvBloc.state, RecommendationEmpty());
  });

  blocTest<RecommendationTvBloc, RecommendationTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesRecommendations.execute(1))
          .thenAnswer((_) async => Right(tTvSeriesList));
      return recommendationTvBloc;
    },
    act: (bloc) => bloc.add(OnLoadDataRecom(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      RecommendationLoading(),
      RecommendationHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesRecommendations.execute(1));
    },
  );

  blocTest<RecommendationTvBloc, RecommendationTvState>(
    'Should emit [Loading, Error] when get Recommendation tv series is unsuccessful',
    build: () {
      when(mockGetTvSeriesRecommendations.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return recommendationTvBloc;
    },
    act: (bloc) => bloc.add(OnLoadDataRecom(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      RecommendationLoading(),
      RecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesRecommendations.execute(1));
    },
  );
}
