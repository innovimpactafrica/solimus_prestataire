abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess<T> extends AuthState {
  final T data;
  const AuthSuccess(this.data);
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
