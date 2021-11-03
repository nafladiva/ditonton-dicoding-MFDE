import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:detail/presentation/bloc/detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:detail/domain/usecases/get_movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late DetailBloc detailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    detailBloc = DetailBloc(mockGetMovieDetail);
  });

  test('initial state should be empty', () {
    expect(detailBloc.state, DetailEmpty());
  });

  blocTest<DetailBloc, DetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Right(testMovieDetail));
      return detailBloc;
    },
    act: (bloc) => bloc.add(OnLoadData(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      DetailLoading(),
      DetailHasData(testMovieDetail),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(1));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'Should emit [Loading, Error] when get detail movie is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailBloc;
    },
    act: (bloc) => bloc.add(OnLoadData(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      DetailLoading(),
      DetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(1));
    },
  );
}
