class APIEndpoint {
  static const String baseURL = "https://alfabets.dsrt321.online/api/";


  // Authentication Endpoints
  static const String login = "${baseURL}authentication/login/";
  static const String signup = "${baseURL}authentication/send-registration-otp/";
  static const String verifyRegOTP = "${baseURL}authentication/verify-registration-otp/";


  static String footballLiveMatch ="${baseURL}sports-data/live-matches/";
  static String leagueList ="${baseURL}sports-data/leagues/";
  static String leagueDetail ="${baseURL}sports-data/leagues";

  static String newsList ="${baseURL}sports-data/news/personalized/";
  static String addToFavorite ="${baseURL}sports-data/user/favorites/";
  static  String userFavorites = "${baseURL}sports-data/user/favorites/";

}