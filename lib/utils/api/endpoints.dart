class Endpoints{
  static const String BASE_URL = 'http://192.168.77.41:3000';

  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh_token  = '/auth/refresh';

  static const String user = '/users';
  static const String user_profile = '/users/profile';
  static const String update_user_profile = '/users/update';
  static const String register_professional =  '/registration/professional';

  static const String bookings_list = '/bookings/id';
  static const String bookings = '/bookings/status';
  static const String search_bookings = '/bookings/search';
  static const String update_bookings = '/bookings/update/status';
  static const String update_booking_payment = '/bookings/update/payment';

  static const String dashboard = '/dashboard';
  static const String dashboard_graph = '/dashboard/earnings/graph';
  static const String dashboard_upcoming = '/dashboard/upcoming-booking';
  static const String review_fetch = '/reviews';

  static const String payment_bank = '/payment/bank';
  static const String payment_upi = '/payment/upi';
  static const String payment_add_bank = '/add/bank';
  static const String payment_add_upi = '/add/upi';
  static const String payment_update_bank = '/update/primaryBank';
  static const String payment_update_upi = '/update/primaryUpi';
  static const String payment_delete_bank = '/payment/d/bank';
  static const String payment_delete_upi = '/payment/d/upi';
  static const String payment_primary = '/payment/primary';

  static const String profile = '/profile';
  static const String update_profile = '/update/profile';
  static const String upload_certificate = '/upload/certificate';
  static const String upload_image = '/upload/profile';
  static const String delete_image = '/d/profimg';

  static const String notification = '/notification';
  static const String notification_send = '/send';
  static const String notification_update = '/update/fcmtoken';

  static const String message = '/messages';
}