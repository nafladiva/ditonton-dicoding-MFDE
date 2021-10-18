import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/season_detail_page.dart';
import 'package:ditonton/presentation/provider/tvseries/season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'season_detail_page_test.mocks.dart';

@GenerateMocks([SeasonDetailNotifier])
void main() {
  late MockSeasonDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockSeasonDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<SeasonDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.seasonState).thenReturn(RequestState.Loading);

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
    when(mockNotifier.seasonState).thenReturn(RequestState.Loaded);
    when(mockNotifier.season).thenReturn(testSeasonDetail);

    final seasonContentFinder = find.byType(SeasonContent);
    final episodeContentFinder = find.byType(EpisodeContent);

    await tester.pumpWidget(_makeTestableWidget(SeasonDetailPage(
      tvId: 1,
      seasonNum: 1,
    )));

    expect(seasonContentFinder, findsOneWidget);
    expect(episodeContentFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.seasonState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.text('Error message');

    await tester.pumpWidget(_makeTestableWidget(SeasonDetailPage(
      tvId: 1,
      seasonNum: 1,
    )));

    expect(textFinder, findsOneWidget);
  });
}
