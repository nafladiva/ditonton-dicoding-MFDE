import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/utils/failure.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late RecommendationBloc recommendationBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  final tMovieList = <Movie>[testMovie];

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    recommendationBloc = RecommendationBloc(mockGetMovieRecommendations);
  });

  test('initial state should be empty', () {
    expect(recommendationBloc.state, RecommendationEmpty());
  });

  blocTest<RecommendationBloc, RecommendationState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Right(tMovieList));
      return recommendationBloc;
    },
    act: (bloc) => bloc.add(OnLoadDataRecom(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      RecommendationLoading(),
      RecommendationHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(1));
    },
  );

  blocTest<RecommendationBloc, RecommendationState>(
    'Should emit [Loading, Error] when get Recommendation movie is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return recommendationBloc;
    },
    act: (bloc) => bloc.add(OnLoadDataRecom(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      RecommendationLoading(),
      RecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(1));
    },
  );
}
