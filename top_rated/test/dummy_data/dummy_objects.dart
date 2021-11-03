import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tvseries.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testTvSeries = TvSeries(
  backdropPath: "/gFZriCkpJYsApPZEF3jhxL4yLzG.jpg",
  firstAirDate: "2017-05-02",
  genreIds: [80, 18],
  id: 71446,
  name: "Money Heist",
  originCountry: ["ES"],
  originalLanguage: "es",
  originalName: "La Casa de Papel",
  overview:
      "To carry out the biggest heist in history, a mysterious man called The Professor recruits a band of eight robbers who have a single characteristic: none of them has anything to lose. Five months of seclusion - memorizing every step, every detail, every probability - culminate in eleven days locked up in the National Coinage and Stamp Factory of Spain, surrounded by police forces and with dozens of hostages in their power, to find out whether their suicide wager will lead to everything or nothing.",
  popularity: 821.955,
  posterPath: "/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg",
  voteAverage: 8.3,
  voteCount: 14704,
);
