import 'package:jwt_decoder/jwt_decoder.dart';

/// Return expired date time of token
DateTime jwtExpiredDateTime(String token) =>
    JwtDecoder.getExpirationDate(token);
