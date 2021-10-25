import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:core/presentation/pages/popular_tvseries_page.dart';
import 'package:core/presentation/pages/tvseries_detail_page.dart';
import 'package:core/presentation/provider/tvseries/popular_tvseries_notifier.dart';
import 'package:core/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_tvseries_page_test.mocks.dart';

@GenerateMocks([PopularTvSeriesNotifier])
void main() {
  late MockPopularTvSeriesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockPopularTvSeriesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularTvSeriesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(<TvSeries>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display tv series card when data loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(<TvSeries>[testTvSeries]);

    final tvSeriesCardFinder = find.byType(TvSeriesCard);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(tvSeriesCardFinder, findsOneWidget);
  });

  testWidgets('onTap Tv Series card from popular tv series page',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(<TvSeries>[testTvSeries]);

    await tester
        .pumpWidget(ChangeNotifierProvider<PopularTvSeriesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
          home: PopularTvSeriesPage(),
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
