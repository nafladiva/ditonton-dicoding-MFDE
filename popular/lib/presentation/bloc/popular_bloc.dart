import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:popular/domain/usecases/get_popular_movies.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopularMovies _popularMovies;

  PopularBloc(this._popularMovies) : super(PopularEmpty());

  @override
  Stream<PopularState> mapEventToState(
    PopularEvent event,
  ) async* {
    if (event is OnLoadData) {
      yield PopularLoading();
      final result = await _popularMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield PopularError(failure.message);
        },
        (data) async* {
          yield PopularHasData(data);
        },
      );
    }
  }
}
