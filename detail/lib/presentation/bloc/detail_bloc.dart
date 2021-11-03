import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:detail/domain/usecases/get_movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail _detailMovies;

  DetailBloc(this._detailMovies) : super(DetailEmpty());

  @override
  Stream<DetailState> mapEventToState(
    DetailEvent event,
  ) async* {
    if (event is OnLoadData) {
      final movieId = event.id;

      yield DetailLoading();
      final result = await _detailMovies.execute(movieId);

      yield* result.fold(
        (failure) async* {
          yield DetailError(failure.message);
        },
        (data) async* {
          yield DetailHasData(data);
        },
      );
    }
  }
}
