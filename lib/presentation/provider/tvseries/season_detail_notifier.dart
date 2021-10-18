import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/usecases/tvseries/get_season_detail.dart';
import 'package:flutter/cupertino.dart';

class SeasonDetailNotifier extends ChangeNotifier {
  final GetSeasonDetail getSeasonDetail;

  SeasonDetailNotifier({required this.getSeasonDetail});

  late SeasonDetail _season;
  SeasonDetail get season => _season;

  RequestState _seasonState = RequestState.Empty;
  RequestState get seasonState => _seasonState;

  String _message = '';
  String get message => _message;

  Future<void> fetchSeasonDetail(int id, int season) async {
    _seasonState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getSeasonDetail.execute(id, season);
    detailResult.fold(
      (failure) {
        _seasonState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (season) {
        _season = season;
        notifyListeners();

        _seasonState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
