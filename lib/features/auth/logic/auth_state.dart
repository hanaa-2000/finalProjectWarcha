part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthUserTypeSelected extends AuthState {
  final String userType;
  AuthUserTypeSelected(this.userType);
}
final class LoginLoading extends AuthState {}
final class LoginSuccess extends AuthState {
  final User user;
  final String userType;
  LoginSuccess(this.user,this.userType);
}
final class LoginFailure extends AuthState {

  final String errorMsg;

  LoginFailure({required this.errorMsg});
}

final class SignUpLoading extends AuthState {}
final class SignUpSuccess extends AuthState {
  final User user;
  SignUpSuccess(this.user);
}
// class AuthUnauthenticated extends AuthState {
//   final String userType;
//   AuthUnauthenticated(this.userType);
// }
final class SignUpFailure extends AuthState {

  final String errorMsg;

  SignUpFailure({required this.errorMsg});
}





class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String userType;
  final User user;
  AuthSuccess(this.user ,this.userType);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
