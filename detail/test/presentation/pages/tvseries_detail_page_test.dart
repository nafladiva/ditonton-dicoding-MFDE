import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:detail/presentation/bloc/detail_tv_bloc.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_tv_bloc.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_tv_bloc.dart';
import 'package:detail/presentation/pages/tvseries_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeDetailTvEvent extends Fake implements DetailTvEvent {}

class FakeDetailTvState extends Fake implements DetailTvState {}

class FakeRecommendationTvEvent extends Fake implements RecommendationTvEvent {}

class FakeRecommendationTvState extends Fake implements RecommendationTvState {}

class FakeWatchlistStatusTvEvent extends Fake
    implements WatchlistStatusTvEvent {}

class FakeWatchlistStatusTvState extends Fake
    implements WatchlistStatusTvState {}

class MockDetailTvBloc extends MockBloc<DetailTvEvent, DetailTvState>
    implements DetailTvBloc {}

class MockRecommendationTvBloc
    extends MockBloc<RecommendationTvEvent, RecommendationTvState>
    implements RecommendationTvBloc {}

class MockWatchlistStatusTvBloc
    extends MockBloc<WatchlistStatusTvEvent, WatchlistStatusTvState>
    implements WatchlistStatusTvBloc {}

void main() {
  late MockDetailTvBloc mockDetailTvBloc;
  late MockRecommendationTvBloc mockRecommendationTvBloc;
  late MockWatchlistStatusTvBloc mockWatchlistStatusTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeDetailTvState());
    registerFallbackValue(FakeDetailTvEvent());

    registerFallbackValue(FakeRecommendationTvState());
    registerFallbackValue(FakeRecommendationTvEvent());

    registerFallbackValue(FakeWatchlistStatusTvState());
    registerFallbackValue(FakeWatchlistStatusTvEvent());

    mockDetailTvBloc = MockDetailTvBloc();
    mockRecommendationTvBloc = MockRecommendationTvBloc();
    mockWatchlistStatusTvBloc = MockWatchlistStatusTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailTvBloc>(create: (_) => mockDetailTvBloc),
        BlocProvider<RecommendationTvBloc>(
            create: (_) => mockRecommendationTvBloc),
        BlocProvider<WatchlistStatusTvBloc>(
            create: (_) => mockWatchlistStatusTvBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state)
        .thenReturn(DetailHasData(testTvSeriesDetail));
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationHasData(<TvSeries>[testTvSeries]));
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(UpdateWatchlist(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state)
        .thenReturn(DetailHasData(testTvSeriesDetail));
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationHasData(<TvSeries>[testTvSeries]));
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(UpdateWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state)
        .thenReturn(DetailHasData(testTvSeriesDetail));
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationHasData(<TvSeries>[testTvSeries]));
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(UpdateWatchlist(false));
    when(() => mockWatchlistStatusTvBloc.watchlistMessage)
        .thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump(new Duration(milliseconds: 300));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state)
        .thenReturn(DetailHasData(testTvSeriesDetail));
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationHasData(<TvSeries>[testTvSeries]));
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(UpdateWatchlist(true));
    when(() => mockWatchlistStatusTvBloc.watchlistMessage)
        .thenReturn('Removed to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump(new Duration(milliseconds: 300));

    expect(find.text('Removed to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state)
        .thenReturn(DetailHasData(testTvSeriesDetail));
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationHasData(<TvSeries>[testTvSeries]));
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(UpdateWatchlist(false));
    when(() => mockWatchlistStatusTvBloc.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump(new Duration(milliseconds: 300));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state).thenReturn(DetailLoading());
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationTvInitial());
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(WatchlistTvInitial());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations list should display center progress bar when load data',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state)
        .thenReturn(DetailHasData(testTvSeriesDetail));
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationLoading());
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(UpdateWatchlist(false));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(centerFinder, findsWidgets);
    expect(progressBarFinder, findsWidgets);
  });

  testWidgets(
      'Recommendations list should display listview when data is loaded',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state)
        .thenReturn(DetailHasData(testTvSeriesDetail));
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationHasData(<TvSeries>[testTvSeries]));
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(UpdateWatchlist(false));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(listViewFinder, findsWidgets);
  });

  testWidgets(
      'Page should display recommendationContent widget when recommendation data loaded',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state)
        .thenReturn(DetailHasData(testTvSeriesDetail));
    when(() => mockRecommendationTvBloc.state)
        .thenReturn(RecommendationHasData(<TvSeries>[testTvSeries]));
    when(() => mockWatchlistStatusTvBloc.state)
        .thenReturn(UpdateWatchlist(false));

    final recommendationFinder = find.byType(RecommendationContentTv);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(recommendationFinder, findsOneWidget);
  });
}
