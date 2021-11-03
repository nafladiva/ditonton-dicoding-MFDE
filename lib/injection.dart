import 'dart:io';

import 'package:core/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:core/presentation/bloc/list/movies/now_playing_movie_list_bloc.dart';
import 'package:core/presentation/bloc/list/movies/popular_movie_list_bloc.dart';
import 'package:core/presentation/bloc/list/movies/top_rated_movie_list_bloc.dart';
import 'package:core/presentation/bloc/list/tvseries/now_playing_tv_list_bloc.dart';
import 'package:core/presentation/bloc/list/tvseries/popular_tv_list_bloc.dart';
import 'package:core/presentation/bloc/list/tvseries/top_rated_tv_list_bloc.dart';
import 'package:detail/presentation/bloc/detail_bloc.dart';
import 'package:detail/presentation/bloc/detail_tv_bloc.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_bloc.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_tv_bloc.dart';
import 'package:detail/presentation/bloc/season_tvseries/season_tv_bloc.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_tv_bloc.dart';
import 'package:flutter/services.dart';
import 'package:popular/presentation/bloc/popular_bloc.dart';
import 'package:popular/presentation/bloc/popular_tv_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tvseries_local_data_source.dart';
import 'package:core/data/datasources/tvseries_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:detail/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:popular/domain/usecases/get_popular_movies.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';
import 'package:toprated/presentation/bloc/top_rated_bloc.dart';
import 'package:toprated/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:toprated/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:core/domain/usecases/tvseries/get_now_playing_tvseries.dart';
import 'package:core/domain/usecases/tvseries/get_season_detail.dart';
import 'package:core/domain/usecases/tvseries/get_watchlist_status_tv.dart';
import 'package:core/domain/usecases/tvseries/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/tvseries/save_watchlist_tv.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:get_it/get_it.dart';

import 'package:core/data/repositories/tvseries_repository_impl.dart';
import 'package:core/domain/repositories/tvseries_repository.dart';
import 'package:popular/domain/usecases/get_popular_tvseries.dart';
import 'package:toprated/domain/usecases/get_top_rated_tvseries.dart';
import 'package:detail/domain/usecases/get_tvseries_detail.dart';
import 'package:core/domain/usecases/tvseries/get_tvseries_recommendations.dart';
import 'package:core/domain/usecases/tvseries/get_watchlist_tvseries.dart';
import 'package:search/domain/usecases/search_tvseries.dart';

final locator = GetIt.instance;

void init() {
  /**
   * Movies
   */

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerSingletonAsync<IOClient>(() async {
    final sslCert =
        await rootBundle.load('assets/certificates/certificate.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    final HttpClient httpClient = HttpClient(context: securityContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    var client = IOClient(httpClient);

    return client;
  });

  //bloc
  locator.registerFactory(
    () => SearchBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => DetailBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => RecommendationBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistStatusBloc(
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistBloc(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingMovieListBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMovieListBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMovieListBloc(
      locator(),
    ),
  );

  /**
   * TV Series
   */

  // use case
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetSeasonDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  //bloc
  locator.registerFactory(
    () => SearchTvBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => DetailTvBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => RecommendationTvBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistStatusTvBloc(
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => SeasonTvBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingTvSeriesListBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvSeriesListBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvSeriesListBloc(
      locator(),
    ),
  );
}
