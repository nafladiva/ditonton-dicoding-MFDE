import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchListStatus, SaveWatchlist, RemoveWatchlist])
void main() {
  late WatchlistStatusBloc watchlistBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistBloc = WatchlistStatusBloc(
        mockGetWatchListStatus, mockSaveWatchlist, mockRemoveWatchlist);
  });

  test('initial state should be empty', () {
    expect(watchlistBloc.state, WatchlistInitial());
  });

  blocTest<WatchlistStatusBloc, WatchlistStatusState>(
    'Should emit [UpdateWatchlist] when data is gotten successfully on event OnCurrentStatus',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(OnCurrentStatus(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      UpdateWatchlist(false),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(1));
    },
  );

  blocTest<WatchlistStatusBloc, WatchlistStatusState>(
    'Should emit [UpdateWatchlist] when data is gotten successfully on event AddingWatchlist',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(AddingWatchlist(testMovieDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      UpdateWatchlist(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(1));
    },
  );

  blocTest<WatchlistStatusBloc, WatchlistStatusState>(
    'Should emit [UpdateWatchlist] when data is gotten successfully on event RemovingWatchlist',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(RemovingWatchlist(testMovieDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      UpdateWatchlist(false),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(1));
    },
  );
}
