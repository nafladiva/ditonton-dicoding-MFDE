import 'package:bloc_test/bloc_test.dart';
import 'package:detail/presentation/bloc/season_tvseries/season_tv_bloc.dart';
import 'package:detail/presentation/pages/season_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeSeasonTvEvent extends Fake implements SeasonTvEvent {}

class FakeSeasonTvState extends Fake implements SeasonTvState {}

class MockSeasonTvBloc extends MockBloc<SeasonTvEvent, SeasonTvState>
    implements SeasonTvBloc {}

void main() {
  late MockSeasonTvBloc mockSeasonTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeSeasonTvState());
    registerFallbackValue(FakeSeasonTvEvent());
    mockSeasonTvBloc = MockSeasonTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SeasonTvBloc>.value(
      value: mockSeasonTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockSeasonTvBloc.state).thenReturn(SeasonLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(SeasonDetailPage(
      tvId: 1,
      seasonNum: 1,
    )));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display SeasonContent and EpisodeContent when data is loaded',
      (WidgetTester tester) async {
    when(() => mockSeasonTvBloc.state)
        .thenReturn(SeasonHasData(testSeasonDetail));

    final seasonContentFinder = find.byType(SeasonContent);
    final episodeContentFinder = find.byType(EpisodeContent);

    await tester.pumpWidget(_makeTestableWidget(SeasonDetailPage(
      tvId: 1,
      seasonNum: 1,
    )));

    expect(seasonContentFinder, findsOneWidget);
    expect(episodeContentFinder, findsOneWidget);
  });
}
