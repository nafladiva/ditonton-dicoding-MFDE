import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/presentation/pages/top_rated_tvseries_page.dart';
import 'package:ditonton/presentation/pages/tvseries_detail_page.dart';
import 'package:ditonton/presentation/provider/tvseries/top_rated_tvseries_notifier.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_tvseries_page_test.mocks.dart';

@GenerateMocks([TopRatedTvSeriesNotifier])
void main() {
  late MockTopRatedTvSeriesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedTvSeriesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTvSeriesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(<TvSeries>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display tvseries card when data loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(<TvSeries>[testTvSeries]);

    final tvSeriesCardFinder = find.byType(TvSeriesCard);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(tvSeriesCardFinder, findsOneWidget);
  });

  testWidgets('onTap Tv Series card from top rated tv series page',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(<TvSeries>[testTvSeries]);

    await tester
        .pumpWidget(ChangeNotifierProvider<TopRatedTvSeriesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
          home: TopRatedTvSeriesPage(),
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case TvSeriesDetailPage.ROUTE_NAME:
                return MaterialPageRoute(
                  builder: (_) => Container(),
                  settings: settings,
                );
            }
          }),
    ));

    final tvSeriesCardFinder = find.byKey(Key('tvSeriesCard'));

    expect(tvSeriesCardFinder, findsOneWidget);

    await tester.tap(tvSeriesCardFinder);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(Key('tvSeriesCard')), findsNothing);
  });
}
