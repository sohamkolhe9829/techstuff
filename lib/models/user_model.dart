class UserModel {
  String? uid;
  String? contact;
  String? email;
  String? age;
  String? name;
  String? address;
  bool? isVerify;
  List? cart;

  UserModel({
    this.uid,
    this.email,
    this.age,
    this.name,
    this.contact,
    this.address,
    this.isVerify,
    this.cart,
  });

  // receiving data from Database/Server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      age: map['age'],
      contact: map['contact'],
      address: map['address'],
      isVerify: map['isVerify'],
      cart: map['cart'],
    );
  }

  // sending data to our Database/Server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'contact': '',
      'email': email,
      'age': '',
      'address': '',
      'isVerify': false,
      'name': name,
    };
  }
}
