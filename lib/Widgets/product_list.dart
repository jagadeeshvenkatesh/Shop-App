import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/product.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Pages/productDetailspage.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/constants.dart';

class ProductList extends StatefulWidget {
  final String currentCategory;
  ProductList({this.currentCategory = "all"});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return _buildProducts();
  }

  Widget _buildProducts() {
    User user = Provider.of<User>(context);
    return StreamBuilder(
      stream: DatabaseServices().getProducts(widget.currentCategory),
      builder: (context, AsyncSnapshot<dynamic> snap) {
        List<Product> products = snap.data;
        if (snap.hasData) {
          DatabaseServices().updateCart(user);
          return GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1 / 1.5),
              itemBuilder: (context, index) {
                return _gridViewItem(context, index, products);
              });
        }
        // _buildProductList(products);
        return CircularProgressIndicator();
      },
    );
  }

  void _showToast(String name) {
    Fluttertoast.showToast(
        msg: "$name added to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  Widget _gridViewItem(
      BuildContext context, int index, List<Product> products) {
    Product product = products[index];
    // final snackBar = SnackBar(
    //     duration: Duration(milliseconds: 50),
    //     elevation: 8,
    //     content: Text(
    //       '${product.name} added to Cart!',
    //       style: GoogleFonts.questrial(),
    //     ));
    User user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(
                        product: product,
                      )));
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Opacity(
              opacity: product.outOfStock ? 0.3 : 1,
              child: Container(
                decoration: BoxDecoration(
                    color: kbackgroundColor,
                    boxShadow: [
                      BoxShadow(
                          color: kshadowColor,
                          offset: Offset(8, 6),
                          blurRadius: 12),
                      BoxShadow(
                          color: klightShadowColor,
                          offset: Offset(-8, -6),
                          blurRadius: 12),
                    ],
                    borderRadius: BorderRadius.circular(15)),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 120,
                              width: 150,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Hero(
                                    tag: product.imageurl,
                                    child: Opacity(
                                      opacity: product.outOfStock ? 0.3 : 1,
                                      child: CachedNetworkImage(
                                        imageUrl: product.imageurl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product.name,
                                style: GoogleFonts.manrope(
                                    fontSize: 23, fontWeight: FontWeight.w400),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  product.description,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20.0, top: 5),
                                  child: RichText(
                                    text: TextSpan(
                                        text: '₹ ',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: product.cost,
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: 29)),
                                        ]),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kbackgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: kshadowColor,
                                          offset: Offset(8, 6),
                                          blurRadius: 12),
                                      BoxShadow(
                                          color: klightShadowColor,
                                          offset: Offset(-8, -6),
                                          blurRadius: 12),
                                    ],
                                  ),
                                  child: !product.outOfStock
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            size: 30,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            DatabaseServices()
                                                .addToCart(product, user);
                                            _showToast(product.name);
                                            //  Scaffold.of(context).showSnackBar(snackBar);
                                          })
                                      : Opacity(
                                          opacity: 1,
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Sold\nOut",
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              )

                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 10.0, vertical: 5),
                              //   child: Material(
                              //     elevation: 7,
                              //     shape: CircleBorder(),
                              //     child: CircleAvatar(
                              //       backgroundColor: Colors.orangeAccent,
                              //       child: IconButton(
                              //           icon: Icon(
                              //             CupertinoIcons.add,
                              //             color: Colors.black,
                              //           ),
                              //           onPressed: () {
                              //             DatabaseServices().addToCart(product, user);
                              //           }),
                              //     ),
                              //   ),
                              // )
                            ],
                          )
                        ],
                      ),
                      // product.outOfStock
                      //     ? Center(
                      //         child: Transform.rotate(
                      //             angle: -pi / 4,
                      //             child: Text(
                      //               "Out Of Stock",
                      //               softWrap: true,
                      //               style: TextStyle(color: Colors.red, fontSize: 25),
                      //             )),
                      //       )
                      //     : Container()
                    ],
                  ),
                ),
              ),
            ),
            product.outOfStock
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 120.0),
                      child: Text(
                        "Out Of Stock",
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  // Widget _buildProductList(List<Product> snapshot) {
  //   return Container(
  //     height: 305,
  //     child: ListView(
  //       children: snapshot
  //           .map((data) => _buildProductListItem(context, data))
  //           .toList(),
  //     ),
  //   );
  // }

  // Widget _buildProductListItem(BuildContext context, Product doc) {
  //   // TODO UI
  //   return Text(doc.name);
  // }
}
