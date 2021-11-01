import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/widgets/tvseries_card_list.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toprated/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:toprated/presentation/pages/top_rated_tvseries_page.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeTopRatedTvEvent extends Fake implements TopRatedTvEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedTvState {}

class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

void main() {
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTvState());
    registerFallbackValue(FakeTopRatedTvEvent());
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>.value(
      value: mockTopRatedTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(TopRatedTvHasData([testTvSeries]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(TopRatedTvError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display tv series card when data loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(TopRatedTvHasData([testTvSeries]));

    final tvSeriesCardFinder = find.byType(TvSeriesCard);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(tvSeriesCardFinder, findsOneWidget);
  });

  testWidgets('onTap TvSeries card from TopRated tv series page',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(TopRatedTvHasData([testTvSeries]));

    await tester.pumpWidget(BlocProvider<TopRatedTvBloc>.value(
      value: mockTopRatedTvBloc,
      child: MaterialApp(
          home: TopRatedTvSeriesPage(),
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
