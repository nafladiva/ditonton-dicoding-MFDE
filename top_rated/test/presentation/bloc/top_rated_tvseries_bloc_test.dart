import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:core/utils/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:toprated/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:toprated/domain/usecases/get_top_rated_tvseries.dart';

import 'top_rated_tvseries_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  final tTvSeriesModel = TvSeries(
    backdropPath: "/gFZriCkpJYsApPZEF3jhxL4yLzG.jpg",
    firstAirDate: "2017-05-02",
    genreIds: [80, 18],
    id: 71446,
    name: "Money Heist",
    originCountry: ["ES"],
    originalLanguage: "es",
    originalName: "La Casa de Papel",
    overview:
        "To carry out the biggest heist in history, a mysterious man called The Professor recruits a band of eight robbers who have a single characteristic: none of them has anything to lose. Five months of seclusion - memorizing every step, every detail, every probability - culminate in eleven days locked up in the National Coinage and Stamp Factory of Spain, surrounded by police forces and with dozens of hostages in their power, to find out whether their suicide wager will lead to everything or nothing.",
    popularity: 821.955,
    posterPath: "/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg",
    voteAverage: 8.3,
    voteCount: 14704,
  );

  final tTvSeriesList = <TvSeries>[tTvSeriesModel];

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTvSeries);
  });

  test('initial state should be empty', () {
    expect(topRatedTvBloc.state, TopRatedTvEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(OnLoadData()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, Error] when get top rated movies is unsuccessful',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(OnLoadData()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );
}
