abstract class EndPoints {
  static const String baseUrl = 'https://backend-5xnh.vercel.app/';

  static const String authUrl = '${baseUrl}auth/';
  static const String userUrl = '${baseUrl}users/';
  static const String chatUrl = '${baseUrl}ai/';
  static const String encyclopediaBase = '${baseUrl}plants/';
  static const String marketUrl = '${baseUrl}market/';
  static const String ordersUrl = '${baseUrl}orders/';
  static const String wishListUrl = '${baseUrl}wishlist/';

  // Auth
  static const String login = '${authUrl}logIn';
  static const String signUp = '${authUrl}signUp';
  static const String verify = '${authUrl}verify';
  static const String resentCode = '${authUrl}resend-code';
  static const String forgetPassword = '${authUrl}forgetPassword';
  static const String resetPassword = '${authUrl}resetPassword';

  //user
  static const String editPersonalData = '${userUrl}edit';
  static const String deleteUser = '${userUrl}delete';
  static const String getProfile = '${userUrl}myprofile';

  //chatbot
  static const String chatbot = '${chatUrl}Chat';

  // Encyclopedia
  static const String getAllPlants = encyclopediaBase;
  static String getPlantyId(String id) => '$encyclopediaBase$id';

  // Market
  static const String getPlantsMarket = marketUrl;
  static const String addPlantForSale = marketUrl;
  static String getPlantDetailsById(String id) => '$getPlantsMarket$id';
  static String updatePlantMarket(String id) => '$getPlantsMarket$id';
  static String deletePlantMarket(String id) => '$getPlantsMarket$id';

  //orders
  static String getAllOrders = '${ordersUrl}my-orders';
  static String getAllRequests = '${ordersUrl}my-requests';
  static String getOrderDetails(String id) => '$ordersUrl$id';
  static String getRequestDetails(String id) => '${ordersUrl}request/$id';

  //wishList
  static String addToWishList = '${wishListUrl}add';
  static String userWishList = wishListUrl;
  static String removeFromWishList = '${wishListUrl}remove';
  static String moveToCart = '${wishListUrl}move-to-cart';
}
