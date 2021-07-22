import 'package:auto_buy/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ProductTile.dart';

class ProductsInSubCategView extends StatelessWidget {

    int TotalitemCount = 0;
   List<Product> ProductsInSubCateg =[];

  ProductsInSubCategView({@required this.TotalitemCount = 0, @required this.ProductsInSubCateg});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 100/130,
      ),

      itemCount: TotalitemCount > 9 ? 9 : TotalitemCount,
      itemBuilder: (BuildContext context, int index) {
        return ProductTile(product: ProductsInSubCateg[index],height: 150,width: 150,);

      },
    );
  }
}
