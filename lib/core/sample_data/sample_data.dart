// import '../../feature/home/models/live_match_response_model.dart';
//
// class SampleLiveMatchData {
//   static LiveMatchResponse getSampleData() {
//     return LiveMatchResponse(
//       status: "success",
//       count: 3,
//       favoriteMatchesCount: 1,
//       otherMatchesCount: 2,
//       isAuthenticated: true,
//       favoritesCount: FavoritesCount(teams: 4, leagues: 2),
//       timestamp: DateTime.now(),
//       matches: [
//         // Match 1: Premier League - Arsenal vs Chelsea (Live)
//         LiveMatch(
//           id: 1001,
//           name: "Arsenal vs Chelsea",
//           startingAt: DateTime.now().subtract(Duration(minutes: 35)),
//           status: MatchStatus(
//             isLive: true,
//             minute: 35,
//             state: "In Play",
//             stateShort: "LIVE",
//             stateId: 1,
//           ),
//           isFavoriteMatch: true,
//           matchReason: ["favorite_team"],
//           league: League(
//             id: 501,
//             name: "Premier League",
//             logo: "https://example.com/premier-league.png",
//             isFavorite: true,
//             country: Country(
//               id: 1,
//               name: "England",
//               code: "GB",
//               flag: "https://example.com/flags/gb.png",
//             ),
//           ),
//           round: Round(
//             id: 2001,
//             name: "Round 15",
//             startingAt: DateTime.now().subtract(Duration(days: 1)),
//             endingAt: DateTime.now().add(Duration(days: 1)),
//           ),
//           homeTeam: Team(
//             id: 101,
//             name: "Arsenal",
//             shortCode: "ARS",
//             logo: "https://c8.alamy.com/comp/CTWFJ9/logo-of-english-football-team-fc-arsenal-CTWFJ9.jpg",
//             location: "London",
//             score: 2,
//             isFavorite: true,
//             statistics: Statistics(value: 58),
//             events: [
//               Event(
//                 id: 3001,
//                 type: "goal",
//                 minute: 12,
//                 extraMinute: null,
//                 participantId: 101,
//                 playerName: "Saka",
//                 relatedPlayerName: "Odegaard",
//                 result: "2-0",
//               ),
//               Event(
//                 id: 3002,
//                 type: "yellowcard",
//                 minute: 28,
//                 extraMinute: null,
//                 participantId: 101,
//                 playerName: "White",
//                 relatedPlayerName: null,
//                 result: null,
//               ),
//             ],
//           ),
//           awayTeam: Team(
//             id: 102,
//             name: "Chelsea",
//             shortCode: "CHE",
//             logo: "https://upload.wikimedia.org/wikipedia/sco/thumb/c/cc/Chelsea_FC.svg/1200px-Chelsea_FC.svg.png",
//             location: "London",
//             score: 1,
//             isFavorite: false,
//             statistics: Statistics(value: 42),
//             events: [
//               Event(
//                 id: 3003,
//                 type: "goal",
//                 minute: 23,
//                 extraMinute: null,
//                 participantId: 102,
//                 playerName: "Jackson",
//                 relatedPlayerName: "Palmer",
//                 result: "1-1",
//               ),
//             ],
//           ),
//           score: MatchScore(home: 2, away: 1, display: "2 - 1"),
//           periods: [
//             Period(
//               id: 4001,
//               typeId: 1,
//               description: "1st Half",
//               started: DateTime.now()
//                   .subtract(Duration(minutes: 35))
//                   .millisecondsSinceEpoch ~/
//                   1000,
//               ended: null,
//               ticking: true,
//               minutes: 35,
//               seconds: 24,
//               timeAdded: 2,
//             ),
//           ],
//           events: [
//             Event(
//               id: 3001,
//               type: "goal",
//               minute: 12,
//               extraMinute: null,
//               participantId: 101,
//               playerName: "Saka",
//               relatedPlayerName: "Odegaard",
//               result: "2-0",
//             ),
//             Event(
//               id: 3003,
//               type: "goal",
//               minute: 23,
//               extraMinute: null,
//               participantId: 102,
//               playerName: "Jackson",
//               relatedPlayerName: "Palmer",
//               result: "1-1",
//             ),
//             Event(
//               id: 3002,
//               type: "yellowcard",
//               minute: 28,
//               extraMinute: null,
//               participantId: 101,
//               playerName: "White",
//               relatedPlayerName: null,
//               result: null,
//             ),
//           ],
//           venue: Venue(
//             id: 5001,
//             name: "Emirates Stadium",
//             city: "London",
//             capacity: 60704,
//             image: "https://example.com/emirates.png",
//           ),
//           predictions: Predictions(
//             fulltimeResult: FulltimeResult(
//               homeWin: 45.5,
//               draw: 28.3,
//               awayWin: 26.2,
//             ),
//             correctScores: CorrectScores(
//               all: {
//                 "1-0": 8.5,
//                 "2-0": 7.2,
//                 "2-1": 9.8,
//                 "1-1": 10.5,
//                 "0-0": 6.3,
//               },
//               top5: [
//                 TopScore(score: "1-1", probability: 10.5),
//                 TopScore(score: "2-1", probability: 9.8),
//                 TopScore(score: "1-0", probability: 8.5),
//                 TopScore(score: "2-0", probability: 7.2),
//                 TopScore(score: "0-0", probability: 6.3),
//               ],
//             ),
//             bothTeamsToScore: BothTeamsToScore(yes: 52.8, no: 47.2),
//             overUnder25: OverUnder(over: 48.5, under: 51.5),
//             doubleChance: DoubleChance(
//               homeOrDraw: 73.8,
//               awayOrDraw: 54.5,
//               homeOrAway: 71.7,
//             ),
//           ),
//         ),
//
//         // Match 2: La Liga - Real Madrid vs Barcelona (Live)
//         LiveMatch(
//           id: 1002,
//           name: "Real Madrid vs Barcelona",
//           startingAt: DateTime.now().subtract(Duration(minutes: 67)),
//           status: MatchStatus(
//             isLive: true,
//             minute: 67,
//             state: "In Play",
//             stateShort: "LIVE",
//             stateId: 1,
//           ),
//           isFavoriteMatch: false,
//           matchReason: [],
//           league: League(
//             id: 502,
//             name: "La Liga",
//             logo: "https://example.com/laliga.png",
//             isFavorite: false,
//             country: Country(
//               id: 2,
//               name: "Spain",
//               code: "ES",
//               flag: "https://example.com/flags/es.png",
//             ),
//           ),
//           round: Round(
//             id: 2002,
//             name: "Matchday 16",
//             startingAt: DateTime.now().subtract(Duration(days: 2)),
//             endingAt: DateTime.now().add(Duration(hours: 12)),
//           ),
//           homeTeam: Team(
//             id: 103,
//             name: "Real Madrid",
//             shortCode: "RMA",
//             logo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsOtaZOeDkFKkV5TgjAPQ2xc2lIYHmQg_ExQ&s",
//             location: "Madrid",
//             score: 1,
//             isFavorite: false,
//             statistics: Statistics(value: 55),
//             events: [
//               Event(
//                 id: 3004,
//                 type: "goal",
//                 minute: 34,
//                 extraMinute: null,
//                 participantId: 103,
//                 playerName: "Bellingham",
//                 relatedPlayerName: "Vinicius Jr",
//                 result: "1-0",
//               ),
//             ],
//           ),
//           awayTeam: Team(
//             id: 104,
//             name: "Barcelona",
//             shortCode: "BAR",
//             logo: "https://1000logos.net/wp-content/uploads/2016/10/Barcelona-Logo.png",
//             location: "Barcelona",
//             score: 1,
//             isFavorite: true,
//             statistics: Statistics(value: 45),
//             events: [
//               Event(
//                 id: 3005,
//                 type: "goal",
//                 minute: 51,
//                 extraMinute: null,
//                 participantId: 104,
//                 playerName: "Lewandowski",
//                 relatedPlayerName: "Gundogan",
//                 result: "1-1",
//               ),
//               Event(
//                 id: 3006,
//                 type: "yellowcard",
//                 minute: 63,
//                 extraMinute: null,
//                 participantId: 104,
//                 playerName: "Araujo",
//                 relatedPlayerName: null,
//                 result: null,
//               ),
//             ],
//           ),
//           score: MatchScore(home: 1, away: 1, display: "1 - 1"),
//           periods: [
//             Period(
//               id: 4002,
//               typeId: 1,
//               description: "1st Half",
//               started: DateTime.now()
//                   .subtract(Duration(minutes: 67))
//                   .millisecondsSinceEpoch ~/
//                   1000,
//               ended: DateTime.now()
//                   .subtract(Duration(minutes: 22))
//                   .millisecondsSinceEpoch ~/
//                   1000,
//               ticking: false,
//               minutes: 45,
//               seconds: 0,
//               timeAdded: 3,
//             ),
//             Period(
//               id: 4003,
//               typeId: 2,
//               description: "2nd Half",
//               started: DateTime.now()
//                   .subtract(Duration(minutes: 22))
//                   .millisecondsSinceEpoch ~/
//                   1000,
//               ended: null,
//               ticking: true,
//               minutes: 22,
//               seconds: 15,
//               timeAdded: null,
//             ),
//           ],
//           events: [
//             Event(
//               id: 3004,
//               type: "goal",
//               minute: 34,
//               extraMinute: null,
//               participantId: 103,
//               playerName: "Bellingham",
//               relatedPlayerName: "Vinicius Jr",
//               result: "1-0",
//             ),
//             Event(
//               id: 3005,
//               type: "goal",
//               minute: 51,
//               extraMinute: null,
//               participantId: 104,
//               playerName: "Lewandowski",
//               relatedPlayerName: "Gundogan",
//               result: "1-1",
//             ),
//             Event(
//               id: 3006,
//               type: "yellowcard",
//               minute: 63,
//               extraMinute: null,
//               participantId: 104,
//               playerName: "Araujo",
//               relatedPlayerName: null,
//               result: null,
//             ),
//           ],
//           venue: Venue(
//             id: 5002,
//             name: "Santiago Bernabeu",
//             city: "Madrid",
//             capacity: 81044,
//             image: "https://example.com/bernabeu.png",
//           ),
//           predictions: Predictions(
//             fulltimeResult: FulltimeResult(
//               homeWin: 38.2,
//               draw: 29.5,
//               awayWin: 32.3,
//             ),
//             correctScores: CorrectScores(
//               all: {
//                 "1-1": 11.2,
//                 "2-1": 8.9,
//                 "1-2": 8.1,
//                 "2-2": 7.5,
//                 "1-0": 7.8,
//               },
//               top5: [
//                 TopScore(score: "1-1", probability: 11.2),
//                 TopScore(score: "2-1", probability: 8.9),
//                 TopScore(score: "1-2", probability: 8.1),
//                 TopScore(score: "1-0", probability: 7.8),
//                 TopScore(score: "2-2", probability: 7.5),
//               ],
//             ),
//             bothTeamsToScore: BothTeamsToScore(yes: 58.3, no: 41.7),
//             overUnder25: OverUnder(over: 52.1, under: 47.9),
//             doubleChance: DoubleChance(
//               homeOrDraw: 67.7,
//               awayOrDraw: 61.8,
//               homeOrAway: 70.5,
//             ),
//           ),
//         ),
//
//         // Match 3: Bundesliga - Bayern Munich vs Dortmund (Upcoming)
//         LiveMatch(
//           id: 1003,
//           name: "Bayern Munich vs Borussia Dortmund",
//           startingAt: DateTime.now().add(Duration(hours: 2)),
//           status: MatchStatus(
//             isLive: false,
//             minute: null,
//             state: "Not Started",
//             stateShort: "NS",
//             stateId: 0,
//           ),
//           isFavoriteMatch: false,
//           matchReason: [],
//           league: League(
//             id: 503,
//             name: "Bundesliga",
//             logo: "https://example.com/bundesliga.png",
//             isFavorite: true,
//             country: Country(
//               id: 3,
//               name: "Germany",
//               code: "DE",
//               flag: "https://example.com/flags/de.png",
//             ),
//           ),
//           round: Round(
//             id: 2003,
//             name: "Matchday 14",
//             startingAt: DateTime.now().subtract(Duration(hours: 6)),
//             endingAt: DateTime.now().add(Duration(days: 2)),
//           ),
//           homeTeam: Team(
//             id: 105,
//             name: "Bayern Munich",
//             shortCode: "BAY",
//             logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/FC_Bayern_M%C3%BCnchen_logo_%282017%29.svg/1024px-FC_Bayern_M%C3%BCnchen_logo_%282017%29.svg.png",
//             location: "Munich",
//             score: 0,
//             isFavorite: true,
//             statistics: null,
//             events: [],
//           ),
//           awayTeam: Team(
//             id: 106,
//             name: "Borussia Dortmund",
//             shortCode: "BVB",
//             logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Borussia_Dortmund_logo.svg/1024px-Borussia_Dortmund_logo.svg.png",
//             location: "Dortmund",
//             score: 0,
//             isFavorite: true,
//             statistics: null,
//             events: [],
//           ),
//           score: MatchScore(home: 0, away: 0, display: "- : -"),
//           periods: [],
//           events: [],
//           venue: Venue(
//             id: 5003,
//             name: "Allianz Arena",
//             city: "Munich",
//             capacity: 75024,
//             image: "https://example.com/allianz.png",
//           ),
//           predictions: Predictions(
//             fulltimeResult: FulltimeResult(
//               homeWin: 52.7,
//               draw: 25.1,
//               awayWin: 22.2,
//             ),
//             correctScores: CorrectScores(
//               all: {
//                 "2-1": 10.5,
//                 "1-0": 9.2,
//                 "2-0": 8.8,
//                 "1-1": 9.9,
//                 "3-1": 7.1,
//               },
//               top5: [
//                 TopScore(score: "2-1", probability: 10.5),
//                 TopScore(score: "1-1", probability: 9.9),
//                 TopScore(score: "1-0", probability: 9.2),
//                 TopScore(score: "2-0", probability: 8.8),
//                 TopScore(score: "3-1", probability: 7.1),
//               ],
//             ),
//             bothTeamsToScore: BothTeamsToScore(yes: 55.6, no: 44.4),
//             overUnder25: OverUnder(over: 51.3, under: 48.7),
//             doubleChance: DoubleChance(
//               homeOrDraw: 77.8,
//               awayOrDraw: 47.3,
//               homeOrAway: 74.9,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Method to get a single match by ID
//   static LiveMatch? getMatchById(int id) {
//     final response = getSampleData();
//     try {
//       return response.matches.firstWhere((match) => match.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Method to get only live matches
//   static List<LiveMatch> getLiveMatches() {
//     final response = getSampleData();
//     return response.matches.where((match) => match.status.isLive).toList();
//   }
//
//   // Method to get favorite matches
//   static List<LiveMatch> getFavoriteMatches() {
//     final response = getSampleData();
//     return response.matches.where((match) => match.isFavoriteMatch).toList();
//   }
// }