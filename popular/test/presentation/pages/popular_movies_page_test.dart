import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:popular/presentation/bloc/popular_bloc.dart';
import 'package:popular/presentation/pages/popular_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';

class FakePopularEvent extends Fake implements PopularEvent {}

class FakePopularState extends Fake implements PopularState {}

class MockPopularBloc extends MockBloc<PopularEvent, PopularState>
    implements PopularBloc {}

void main() {
  late MockPopularBloc mockPopularBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularState());
    registerFallbackValue(FakePopularEvent());
    mockPopularBloc = MockPopularBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularBloc>.value(
      value: mockPopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularBloc.state).thenReturn(PopularLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularBloc.state).thenReturn(PopularHasData([testMovie]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockPopularBloc.state).thenReturn(PopularError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display movie card when data loaded',
      (WidgetTester tester) async {
    when(() => mockPopularBloc.state).thenReturn(PopularHasData([testMovie]));

    final movieCardFinder = find.byType(MovieCard);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(movieCardFinder, findsOneWidget);
  });

  testWidgets('onTap Movie card from popular movies page',
      (WidgetTester tester) async {
    when(() => mockPopularBloc.state).thenReturn(PopularHasData([testMovie]));

    await tester.pumpWidget(BlocProvider<PopularBloc>.value(
      value: mockPopularBloc,
      child: MaterialApp(
          home: PopularMoviesPage(),
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case MOVIE_DETAIL_ROUTE:
                return MaterialPageRoute(
                  builder: (_) => Container(),
                  settings: settings,
                );
            }
          }),
    ));

    final movieCardFinder = find.byKey(Key('movieCard'));

    expect(movieCardFinder, findsOneWidget);

    await tester.tap(movieCardFinder);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(Key('movieCard')), findsNothing);
  });
}
