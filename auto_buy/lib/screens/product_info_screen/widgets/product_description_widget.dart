import 'package:auto_buy/widgets/common_styles.dart';
import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget {
  final String productDescription;
  final String productBrand;
  final String productCategory;
  final String productSubCategory;
  final double productSize;
  final String productSizeUnit;

  const ProductDescription({
    Key key,
    this.productDescription,
    this.productBrand,
    this.productCategory,
    this.productSubCategory,
    this.productSize,
    this.productSizeUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 20, 5, 20),
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      decoration: boxDecorationWithBordersAndShadow(Colors.black),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _descriptionTitleWidget(context),
        SizedBox(height: 10),
        _descriptionContentWidget(context),
        SizedBox(height: 10),
        _buildDescriptionElementWidget(context, "Brand : ", productBrand),
        SizedBox(height: 10),
        _buildDescriptionElementWidget(context, "Category : ", productCategory),
        SizedBox(height: 10),
        _buildDescriptionElementWidget(
            context, "Size : ", '$productSize $productSizeUnit'),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _descriptionContentWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        productDescription,
        textAlign: TextAlign.start,
        softWrap: true,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 0.0446 * MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget _descriptionTitleWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        "Product Description",
        style: TextStyle(
            color: Colors.grey[800],
            fontSize: 0.055 * MediaQuery.of(context).size.width,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildDescriptionElementWidget(
      BuildContext context, String title, String content) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontSize: 0.0456 * MediaQuery.of(context).size.width,
            ),
          ),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 0.0446 * MediaQuery.of(context).size.width,
            ),
          )
        ],
      ),
    );
  }
}
