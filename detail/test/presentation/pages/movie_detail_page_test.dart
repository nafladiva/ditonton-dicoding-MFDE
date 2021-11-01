import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:detail/presentation/bloc/detail_bloc.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_bloc.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:detail/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeDetailEvent extends Fake implements DetailEvent {}

class FakeDetailState extends Fake implements DetailState {}

class FakeRecommendationEvent extends Fake implements RecommendationEvent {}

class FakeRecommendationState extends Fake implements RecommendationState {}

class FakeWatchlistStatusEvent extends Fake implements WatchlistStatusEvent {}

class FakeWatchlistStatusState extends Fake implements WatchlistStatusState {}

class MockDetailBloc extends MockBloc<DetailEvent, DetailState>
    implements DetailBloc {}

class MockRecommendationBloc
    extends MockBloc<RecommendationEvent, RecommendationState>
    implements RecommendationBloc {}

class MockWatchlistStatusBloc
    extends MockBloc<WatchlistStatusEvent, WatchlistStatusState>
    implements WatchlistStatusBloc {}

void main() {
  late MockDetailBloc mockDetailBloc;
  late MockRecommendationBloc mockRecommendationBloc;
  late MockWatchlistStatusBloc mockWatchlistStatusBloc;

  setUpAll(() {
    registerFallbackValue(FakeDetailState());
    registerFallbackValue(FakeDetailEvent());

    registerFallbackValue(FakeRecommendationState());
    registerFallbackValue(FakeRecommendationEvent());

    registerFallbackValue(FakeWatchlistStatusState());
    registerFallbackValue(FakeWatchlistStatusEvent());

    mockDetailBloc = MockDetailBloc();
    mockRecommendationBloc = MockRecommendationBloc();
    mockWatchlistStatusBloc = MockWatchlistStatusBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailBloc>(create: (_) => mockDetailBloc),
        BlocProvider<RecommendationBloc>(create: (_) => mockRecommendationBloc),
        BlocProvider<WatchlistStatusBloc>(
            create: (_) => mockWatchlistStatusBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationHasData(<Movie>[testMovie]));
    when(() => mockWatchlistStatusBloc.state)
        .thenReturn(UpdateWatchlist(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationHasData(<Movie>[testMovie]));
    when(() => mockWatchlistStatusBloc.state).thenReturn(UpdateWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationHasData(<Movie>[testMovie]));
    when(() => mockWatchlistStatusBloc.state)
        .thenReturn(UpdateWatchlist(false));
    when(() => mockWatchlistStatusBloc.watchlistMessage)
        .thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump(new Duration(milliseconds: 300));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationHasData(<Movie>[testMovie]));
    when(() => mockWatchlistStatusBloc.state).thenReturn(UpdateWatchlist(true));
    when(() => mockWatchlistStatusBloc.watchlistMessage)
        .thenReturn('Removed to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump(new Duration(milliseconds: 300));

    expect(find.text('Removed to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationHasData(<Movie>[testMovie]));
    when(() => mockWatchlistStatusBloc.state)
        .thenReturn(UpdateWatchlist(false));
    when(() => mockWatchlistStatusBloc.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump(new Duration(milliseconds: 300));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailLoading());
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationInitial());
    when(() => mockWatchlistStatusBloc.state).thenReturn(WatchlistInitial());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations list should display center progress bar when load data',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationLoading());
    when(() => mockWatchlistStatusBloc.state)
        .thenReturn(UpdateWatchlist(false));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(centerFinder, findsWidgets);
    expect(progressBarFinder, findsWidgets);
  });

  testWidgets(
      'Recommendations list should display listview when data is loaded',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationHasData(<Movie>[testMovie]));
    when(() => mockWatchlistStatusBloc.state)
        .thenReturn(UpdateWatchlist(false));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(listViewFinder, findsWidgets);
  });

  testWidgets(
      'Page should display recommendationContent widget when recommendation data loaded',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationHasData(<Movie>[testMovie]));
    when(() => mockWatchlistStatusBloc.state)
        .thenReturn(UpdateWatchlist(false));

    final recommendationFinder = find.byType(RecommendationContent);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(recommendationFinder, findsOneWidget);
  });
}
