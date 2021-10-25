import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:core/data/models/tvseries_detail_model.dart';
import 'package:core/presentation/pages/season_detail_page.dart';
import 'package:flutter/material.dart';

class SeasonCard extends StatelessWidget {
  final Season season;
  final int tvId;

  SeasonCard(this.season, this.tvId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            SeasonDetailPage.ROUTE_NAME,
            arguments: [tvId, season.seasonNumber],
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(color: Colors.blueGrey[900]),
            child: Row(
              children: [
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: season.posterPath == null
                        ? 'https://via.placeholder.com/100x150?text=No+Image'
                        : '$BASE_IMAGE_URL${season.posterPath}',
                    width: 80,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          season.name,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            season.overview == ""
                                ? "[There's no overview]"
                                : season.overview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            season.episodeCount.toString() + " episodes",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellow[800],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(text: 'See more'),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Icons.arrow_right,
                                  size: 26,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
