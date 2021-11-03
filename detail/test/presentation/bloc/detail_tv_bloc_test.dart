import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:detail/presentation/bloc/detail_tv_bloc.dart';
import 'package:detail/domain/usecases/get_tvseries_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail])
void main() {
  late DetailTvBloc detailTvBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    detailTvBloc = DetailTvBloc(mockGetTvSeriesDetail);
  });

  test('initial state should be empty', () {
    expect(detailTvBloc.state, DetailEmpty());
  });

  blocTest<DetailTvBloc, DetailTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(1))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      return detailTvBloc;
    },
    act: (bloc) => bloc.add(OnLoadData(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      DetailLoading(),
      DetailHasData(testTvSeriesDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(1));
    },
  );

  blocTest<DetailTvBloc, DetailTvState>(
    'Should emit [Loading, Error] when get detail tv series is unsuccessful',
    build: () {
      when(mockGetTvSeriesDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailTvBloc;
    },
    act: (bloc) => bloc.add(OnLoadData(1)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      DetailLoading(),
      DetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(1));
    },
  );
}
