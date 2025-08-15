// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) => OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) => json.encode(data.toJson());

class OrderDetailModel {
    bool? success;
    Data? data;
    String? message;

    OrderDetailModel({
        this.success,
        this.data,
        this.message,
    });

    factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
    };
}

class Data {
    int? id;
    int? idOrder;
    int? idProduct;
    int? qty;
    int? price;
    DateTime? createdAt;
    DateTime? updatedAt;
    Product? product;
    Order? order;

    Data({
        this.id,
        this.idOrder,
        this.idProduct,
        this.qty,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.product,
        this.order,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        idOrder: json["id_order"],
        idProduct: json["id_product"],
        qty: json["qty"],
        price: json["price"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_order": idOrder,
        "id_product": idProduct,
        "qty": qty,
        "price": price,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product": product?.toJson(),
        "order": order?.toJson(),
    };
}

class Order {
    int? id;
    int? idUser;
    String? orderCode;
    int? total;
    DateTime? createdAt;
    DateTime? updatedAt;

    Order({
        this.id,
        this.idUser,
        this.orderCode,
        this.total,
        this.createdAt,
        this.updatedAt,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        idUser: json["id_user"],
        orderCode: json["order_code"],
        total: json["total"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "order_code": orderCode,
        "total": total,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Product {
    int? id;
    String? name;
    String? desc;
    int? price;
    int? stock;
    String? foto;
    int? idCategory;
    DateTime? createdAt;
    DateTime? updatedAt;

    Product({
        this.id,
        this.name,
        this.desc,
        this.price,
        this.stock,
        this.foto,
        this.idCategory,
        this.createdAt,
        this.updatedAt,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        price: json["price"],
        stock: json["stock"],
        foto: json["foto"],
        idCategory: json["id_category"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "price": price,
        "stock": stock,
        "foto": foto,
        "id_category": idCategory,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
