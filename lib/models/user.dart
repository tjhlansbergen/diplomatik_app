import 'dart:ui';

class User {
	int userId;
	String userName;
	int customerId;
	String token;

	User({
		this.userId,
		this.userName,
		this.customerId,
		this.token,
	});

	@override
	String toString() {
		return 'User(userId: $userId, userName: $userName, customerId: $customerId, token: $token)';
	}

	factory User.fromJson(Map<String, dynamic> json) {
		return User(
			userId: json['user_id'] as int,
			userName: json['user_name'] as String,
			customerId: json['customer_id'] as int,
			token: json['token'] as String,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'user_id': userId,
			'user_name': userName,
			'customer_id': customerId,
			'token': token,
		};
	}

	@override
	bool operator ==(Object o) =>
			o is User &&
			identical(o.userId, userId) &&
			identical(o.userName, userName) &&
			identical(o.customerId, customerId) &&
			identical(o.token, token);

	@override
	int get hashCode => hashValues(userId, userName, customerId, token);
}
