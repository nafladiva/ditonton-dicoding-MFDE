import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:detail/presentation/bloc/detail_bloc.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_bloc.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/styles/colors.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DetailBloc>().add(OnLoadData(widget.id));
      context.read<RecommendationBloc>().add(OnLoadDataRecom(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailHasData) {
            final movie = state.result;
            return SafeArea(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 48 + 8),
                    child: DraggableScrollableSheet(
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: kRichBlack,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 16,
                            right: 16,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: kHeading5,
                                      ),
                                      WatchlistButton(movie: movie),
                                      Text(
                                        _showGenres(movie.genres),
                                      ),
                                      Text(
                                        _showDuration(movie.runtime),
                                      ),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: movie.voteAverage / 2,
                                            itemCount: 5,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: kMikadoYellow,
                                            ),
                                            itemSize: 24,
                                          ),
                                          Text('${movie.voteAverage}')
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Overview',
                                        style: kHeading6,
                                      ),
                                      Text(
                                        movie.overview,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Recommendations',
                                        style: kHeading6,
                                      ),
                                      BlocBuilder<RecommendationBloc,
                                          RecommendationState>(
                                        builder: (context, state) {
                                          if (state is RecommendationLoading) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (state
                                              is RecommendationHasData) {
                                            final result =
                                                state.recommendations;
                                            return Container(
                                              height: 150,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  final movie = result[index];
                                                  return RecommendationContent(
                                                      movie: movie);
                                                },
                                                itemCount: result.length,
                                              ),
                                            );
                                          } else if (state
                                              is RecommendationError) {
                                            return Expanded(
                                              child: Center(
                                                child: Text(state.message),
                                              ),
                                            );
                                          } else {
                                            return Expanded(
                                              child: Container(),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  color: Colors.white,
                                  height: 4,
                                  width: 48,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      // initialChildSize: 0.5,
                      minChildSize: 0.25,
                      // maxChildSize: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: kRichBlack,
                      foregroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is DetailError) {
            return Expanded(
              child: Center(
                child: Text(state.message),
              ),
            );
          } else {
            return Expanded(
              child: Container(),
            );
          }
        },
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class WatchlistButton extends StatefulWidget {
  const WatchlistButton({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final MovieDetail movie;

  @override
  _WatchlistButtonState createState() => _WatchlistButtonState();
}

class _WatchlistButtonState extends State<WatchlistButton> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistStatusBloc>().add(OnCurrentStatus(widget.movie.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistStatusBloc, WatchlistStatusState>(
      builder: (context, state) {
        if (state is UpdateWatchlist) {
          final isAddedWatchlist = state.isAdded;
          return ElevatedButton(
            onPressed: () async {
              if (!isAddedWatchlist) {
                context
                    .read<WatchlistStatusBloc>()
                    .add(AddingWatchlist(widget.movie));
              } else {
                context
                    .read<WatchlistStatusBloc>()
                    .add(RemovingWatchlist(widget.movie));
              }

              await Future.delayed(Duration(milliseconds: 300), () {
                final message =
                    context.read<WatchlistStatusBloc>().watchlistMessage;

                if (message == WatchlistStatusBloc.watchlistAddSuccessMessage ||
                    message ==
                        WatchlistStatusBloc.watchlistRemoveSuccessMessage) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(message),
                      );
                    },
                  );
                }
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isAddedWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                Text('Watchlist'),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class RecommendationContent extends StatelessWidget {
  const RecommendationContent({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            MovieDetailPage.ROUTE_NAME,
            arguments: movie.id,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
