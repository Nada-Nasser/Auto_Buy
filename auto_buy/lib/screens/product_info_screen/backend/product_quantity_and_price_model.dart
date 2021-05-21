class ProductQuantityAndPriceModel {
  final int quantity;
 // final bool isProductInWishList;
  final bool isLoading;

  ProductQuantityAndPriceModel({
    this.isLoading = false,
    this.quantity = 1,
    // this.isProductInWishList = false,
  });

  ProductQuantityAndPriceModel copyWith({int quantity, bool isLoading}) {
    return ProductQuantityAndPriceModel(
      quantity: quantity ?? this.quantity,
      //   isProductInWishList: isProductInWishList ?? this.isProductInWishList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
