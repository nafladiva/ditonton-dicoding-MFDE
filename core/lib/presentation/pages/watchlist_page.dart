import 'package:core/utils/state_enum.dart';
import 'package:core/presentation/provider/tvseries/watchlist_tvseries_notifier.dart';
import 'package:core/presentation/provider/watchlist_movie_notifier.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WatchlistMovieNotifier>(context, listen: false)
          .fetchWatchlistMovies();
      Provider.of<WatchlistTvSeriesNotifier>(context, listen: false)
          .fetchWatchlistTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<WatchlistMovieNotifier, WatchlistTvSeriesNotifier>(
          builder: (context, dataMovie, dataTv, child) {
            if (dataMovie.watchlistState == RequestState.Loading &&
                dataTv.watchlistState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataMovie.watchlistState == RequestState.Loaded &&
                dataTv.watchlistState == RequestState.Loaded) {
              return ListView(
                children: <Widget>[
                  ...dataMovie.watchlistMovies.map((movie) {
                    return MovieCard(movie);
                  }).toList(),
                  ...dataTv.watchlistTvSeries.map((tvSeries) {
                    return TvSeriesCard(tvSeries);
                  }).toList(),
                ],
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(dataMovie.message + "\n" + dataTv.message),
              );
            }
          },
        ),
      ),
    );
  }
}
