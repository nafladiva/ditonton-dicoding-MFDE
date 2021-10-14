import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/data/models/tvseries_detail_model.dart';
import 'package:flutter/material.dart';

class SeasonDetailPage extends StatelessWidget {
  static const ROUTE_NAME = '/detail-season';

  final Season season;
  SeasonDetailPage({required this.season});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Season'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              season.name,
              style: kHeading5,
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: season.posterPath == null
                      ? 'https://via.placeholder.com/120x180?text=No+Image'
                      : '$BASE_IMAGE_URL${season.posterPath}',
                  width: 170,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      'Overview',
                      style: kHeading6,
                    ),
                  ),
                  Text(
                    season.overview == ""
                        ? "[There's no overview]"
                        : season.overview,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      'Total Episodes',
                      style: kHeading6,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.yellow[600]),
                    child: Text(
                      season.episodeCount == 0
                          ? "[There's no episode]"
                          : season.episodeCount.toString() + " episodes",
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      'Air Date',
                      style: kHeading6,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.blueGrey[700]),
                    child: Text(
                      season.airDate == null
                          ? "[There's no air date]"
                          : season.airDate.toString(),
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
