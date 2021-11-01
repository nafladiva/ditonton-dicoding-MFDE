import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toprated/domain/usecases/get_top_rated_movies.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  final GetTopRatedMovies _topRatedMovies;

  TopRatedBloc(this._topRatedMovies) : super(TopRatedEmpty());

  @override
  Stream<TopRatedState> mapEventToState(
    TopRatedEvent event,
  ) async* {
    if (event is OnLoadData) {
      yield TopRatedLoading();
      final result = await _topRatedMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield TopRatedError(failure.message);
        },
        (data) async* {
          yield TopRatedHasData(data);
        },
      );
    }
  }
}
