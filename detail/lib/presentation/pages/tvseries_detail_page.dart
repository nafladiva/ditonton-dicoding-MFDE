import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tvseries.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:core/presentation/widgets/season_card_list.dart';
import 'package:detail/presentation/bloc/detail_tv_bloc.dart';
import 'package:detail/presentation/bloc/recommendation/recommendation_tv_bloc.dart';
import 'package:detail/presentation/bloc/watchlist_status/watchlist_status_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/styles/colors.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DetailTvBloc>().add(OnLoadData(widget.id));
      context.read<RecommendationTvBloc>().add(OnLoadDataRecom(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailTvBloc, DetailTvState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailHasData) {
            final tvSeries = state.result;
            return SafeArea(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
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
                                        tvSeries.name,
                                        style: kHeading5,
                                      ),
                                      WatchlistTvButton(tvSeries: tvSeries),
                                      Text(
                                        _showGenres(tvSeries.genres),
                                      ),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: tvSeries.voteAverage / 2,
                                            itemCount: 5,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: kMikadoYellow,
                                            ),
                                            itemSize: 24,
                                          ),
                                          Text('${tvSeries.voteAverage}')
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Overview',
                                        style: kHeading6,
                                      ),
                                      Text(
                                        tvSeries.overview,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Seasons',
                                        style: kHeading6,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          ...tvSeries.seasons.map((item) {
                                            return SeasonCard(
                                                item, tvSeries.id);
                                          }).toList(),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Recommendations',
                                        style: kHeading6,
                                      ),
                                      BlocBuilder<RecommendationTvBloc,
                                              RecommendationTvState>(
                                          builder: (context, state) {
                                        if (state is RecommendationLoading) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (state
                                            is RecommendationHasData) {
                                          final result = state.recommendations;
                                          return Container(
                                            height: 150,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final tv = result[index];
                                                return RecommendationContentTv(
                                                    tv: tv);
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
                                      }),
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
}

class WatchlistTvButton extends StatefulWidget {
  const WatchlistTvButton({
    Key? key,
    required this.tvSeries,
  }) : super(key: key);

  final TvSeriesDetail tvSeries;

  @override
  _WatchlistTvButtonState createState() => _WatchlistTvButtonState();
}

class _WatchlistTvButtonState extends State<WatchlistTvButton> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<WatchlistStatusTvBloc>()
          .add(OnCurrentStatus(widget.tvSeries.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistStatusTvBloc, WatchlistStatusTvState>(
      builder: (context, state) {
        if (state is UpdateWatchlist) {
          final isAddedWatchlist = state.isAdded;
          return ElevatedButton(
            onPressed: () async {
              if (!isAddedWatchlist) {
                context
                    .read<WatchlistStatusTvBloc>()
                    .add(AddingWatchlist(widget.tvSeries));
              } else {
                context
                    .read<WatchlistStatusTvBloc>()
                    .add(RemovingWatchlist(widget.tvSeries));
              }

              await Future.delayed(Duration(milliseconds: 300), () {
                final message =
                    context.read<WatchlistStatusTvBloc>().watchlistMessage;

                if (message ==
                        WatchlistStatusTvBloc.watchlistAddSuccessMessage ||
                    message ==
                        WatchlistStatusTvBloc.watchlistRemoveSuccessMessage) {
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

class RecommendationContentTv extends StatelessWidget {
  const RecommendationContentTv({
    required this.tv,
  });

  final TvSeries tv;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            TvSeriesDetailPage.ROUTE_NAME,
            arguments: tv.id,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
