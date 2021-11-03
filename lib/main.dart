import 'package:core/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:core/presentation/bloc/list/movies/now_playing_movie_list_bloc.dart';
import 'package:core/presentation/bloc/list/movies/popular_movie_list_bloc.dart';
import 'package:core/presentation/bloc/list/movies/top_rated_movie_list_bloc.dart';
import 'package:core/presentation/bloc/list/tvseries/now_playing_tv_list_bloc.dart';
import 'package:core/presentation/bloc/list/tvseries/popular_tv_list_bloc.dart';
import 'package:core/presentation/bloc/list/tvseries/top_rated_tv_list_bloc.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/routes.dart';
import 'package:detail/presentation/bloc/detail_bloc.dart';
import 'package:detail/presentation/bloc/detail_tv_bloc.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_bloc.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_tv_bloc.dart';
import 'package:detail/presentation/bloc/season_tvseries/season_tv_bloc.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_tv_bloc.dart';
import 'package:popular/presentation/bloc/popular_bloc.dart';
import 'package:popular/presentation/bloc/popular_tv_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:about/about.dart';
import 'package:core/presentation/pages/home_tvseries_page.dart';
import 'package:detail/presentation/pages/movie_detail_page.dart';
import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:popular/presentation/pages/popular_movies_page.dart';
import 'package:popular/presentation/pages/popular_tvseries_page.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:search/presentation/pages/search_tvseries_page.dart';
import 'package:detail/presentation/pages/season_detail_page.dart';
import 'package:toprated/presentation/bloc/top_rated_bloc.dart';
import 'package:toprated/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:toprated/presentation/pages/top_rated_movies_page.dart';
import 'package:toprated/presentation/pages/top_rated_tvseries_page.dart';
import 'package:detail/presentation/pages/tvseries_detail_page.dart';
import 'package:core/presentation/pages/watchlist_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import './injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<PopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<RecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistStatusBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<RecommendationTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistStatusTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SeasonTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingMovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingTvSeriesListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvSeriesListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvSeriesListBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          accentColor: kMikadoYellow,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: FutureBuilder(
          future: GetIt.instance.allReady(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return HomeMoviePage();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HOME_MOVIES_ROUTE:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case HOME_TVSERIES_ROUTE:
              return MaterialPageRoute(builder: (_) => HomeTvSeriesPage());
            case POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case POPULAR_TVSERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TOP_RATED_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case TOP_RATED_TVSERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TVSERIES_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SEASON_DETAIL_ROUTE:
              List<dynamic> arg = settings.arguments as List<dynamic>;
              return CupertinoPageRoute(
                builder: (_) =>
                    SeasonDetailPage(tvId: arg[0], seasonNum: arg[1]),
                settings: settings,
              );
            case SEARCH_ROUTE:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case SEARCH_TVSERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => SearchTvSeriesPage());
            case WATCHLIST_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
