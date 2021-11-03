import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/tvseries/get_watchlist_status_tv.dart';
import 'package:core/domain/usecases/tvseries/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/tvseries/save_watchlist_tv.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries
])
void main() {
  late WatchlistStatusTvBloc watchlistTvBloc;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatusTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetWatchListStatusTvSeries = MockGetWatchListStatusTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    watchlistTvBloc = WatchlistStatusTvBloc(mockGetWatchListStatusTvSeries,
        mockSaveWatchlistTvSeries, mockRemoveWatchlistTvSeries);
  });

  test('initial state should be empty', () {
    expect(watchlistTvBloc.state, WatchlistTvInitial());
  });

  blocTest<WatchlistStatusTvBloc, WatchlistStatusTvState>(
    'Should emit [UpdateWatchlist] when current data loaded on event OnCurrentStatus',
    build: () {
      when(mockGetWatchListStatusTvSeries.execute(1))
          .thenAnswer((_) async => false);
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(OnCurrentStatus(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      UpdateWatchlist(false),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatusTvSeries.execute(1));
    },
  );

  blocTest<WatchlistStatusTvBloc, WatchlistStatusTvState>(
    'Should emit [UpdateWatchlist] when data is gotten successfully on event AddingWatchlist',
    build: () {
      when(mockGetWatchListStatusTvSeries.execute(1))
          .thenAnswer((_) async => true);
      when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(AddingWatchlist(testTvSeriesDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      UpdateWatchlist(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatusTvSeries.execute(1));
    },
  );

  blocTest<WatchlistStatusTvBloc, WatchlistStatusTvState>(
    'Should emit [UpdateWatchlist] when data is gotten successfully on event RemovingWatchlist',
    build: () {
      when(mockGetWatchListStatusTvSeries.execute(1))
          .thenAnswer((_) async => false);
      when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(RemovingWatchlist(testTvSeriesDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      UpdateWatchlist(false),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatusTvSeries.execute(1));
    },
  );
}
