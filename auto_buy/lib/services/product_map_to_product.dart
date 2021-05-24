import 'package:auto_buy/models/product_model.dart';


///this Function takes a Map and converts it to a product item
Product createProductFromSnapShot(Map<String,dynamic> alldata){
  return Product(
    name: alldata["name"],
    categoryID: alldata["category_id"],
    id: alldata['id'],
    numberInStock: alldata['number_in_stock'],
    picturePath: alldata['pic_path'],
    price: alldata['price'],
    brand: alldata['brand'],
    hasDiscount: alldata['has_discount'],
    description: alldata['description'],
    priceBeforeDiscount: alldata['price_before_discount'],
    size: alldata['size'],
    sizeUnit: alldata['size_unit'],
    subCategory: alldata['sub_category'],
  );
}