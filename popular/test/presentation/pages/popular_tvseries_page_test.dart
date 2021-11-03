import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/widgets/tvseries_card_list.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:popular/presentation/bloc/popular_tv_bloc.dart';
import 'package:popular/presentation/pages/popular_tvseries_page.dart';

import '../../dummy_data/dummy_objects.dart';

class FakePopularTvEvent extends Fake implements PopularTvEvent {}

class FakePopularTvState extends Fake implements PopularTvState {}

class MockPopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

void main() {
  late MockPopularTvBloc mockPopularTvBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTvState());
    registerFallbackValue(FakePopularTvEvent());
    mockPopularTvBloc = MockPopularTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>.value(
      value: mockPopularTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularTvBloc.state).thenReturn(PopularTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularTvBloc.state)
        .thenReturn(PopularTvHasData([testTvSeries]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockPopularTvBloc.state)
        .thenReturn(PopularTvError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display tv series card when data loaded',
      (WidgetTester tester) async {
    when(() => mockPopularTvBloc.state)
        .thenReturn(PopularTvHasData([testTvSeries]));

    final tvSeriesCardFinder = find.byType(TvSeriesCard);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(tvSeriesCardFinder, findsOneWidget);
  });

  testWidgets('onTap TvSeries card from popular tv series page',
      (WidgetTester tester) async {
    when(() => mockPopularTvBloc.state)
        .thenReturn(PopularTvHasData([testTvSeries]));

    await tester.pumpWidget(BlocProvider<PopularTvBloc>.value(
      value: mockPopularTvBloc,
      child: MaterialApp(
          home: PopularTvSeriesPage(),
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case TVSERIES_DETAIL_ROUTE:
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
