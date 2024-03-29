import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/base/no_data_page.dart';
import 'package:shopping_app/data/controllers/cart_controller.dart';
import 'package:shopping_app/models/cart_model.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/utils/app_constants.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/dimensions.dart';
import 'package:shopping_app/widgets/app_icon.dart';
import 'package:shopping_app/widgets/big_text.dart';
import 'package:shopping_app/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList =
        Get.find<CartController>().getCartHistoryList().reversed.toList();

    Map<String, int> cartItemsPerOrder = {};

    for (int i = 0; i < getCartHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        cartItemsPerOrder.update(
            getCartHistoryList[i].time!, (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    List<int> cartItemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<String> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) => e.key).toList();
    }

    List<int> itemsPerOrder = cartItemsPerOrderToList();

    int listCount = 0;

    Widget timeWidget(int index) {
      var outputDate = DateTime.now().toString();
      if (index < getCartHistoryList.length) {
        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(getCartHistoryList[listCount].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat("dd/MM/yyyy hh:mm a");
        var outputDate = outputFormat.format(inputDate);
      }
      return BigText(text: outputDate);
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            //AppBar
            Container(
              height: Dimensions.height10 * 10,
              color: AppColors.mainColor,
              width: double.infinity,
              padding: EdgeInsets.only(top: Dimensions.height45),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BigText(
                      text: "Cart History",
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteHelper.getCartPage()),
                      child: const AppIcon(
                        icon: Icons.shopping_cart,
                        iconColor: AppColors.mainColor,
                        backgroundColor: AppColors.yellowColor,
                      ),
                    )
                  ]),
            ),
            GetBuilder<CartController>(builder: (cartController) {
              return cartController.getCartHistoryList().isNotEmpty
                  ? Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView(
                            children: [
                              for (int i = 0; i < itemsPerOrder.length; i++)
                                Container(
                                  height: Dimensions.height30 * 4,
                                  margin: EdgeInsets.only(
                                      bottom: Dimensions.height20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      timeWidget(listCount),
                                      SizedBox(height: Dimensions.height10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(
                                            direction: Axis.horizontal,
                                            children: List.generate(
                                                itemsPerOrder[i], (index) {
                                              if (listCount <
                                                  getCartHistoryList.length) {
                                                listCount++;
                                              }
                                              return index <= 2
                                                  ? Container(
                                                      height:
                                                          Dimensions.height20 *
                                                              4,
                                                      width:
                                                          Dimensions.width20 *
                                                              4,
                                                      margin: EdgeInsets.only(
                                                          right: Dimensions
                                                                  .width10 /
                                                              2),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                    .radius15 /
                                                                2),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(AppConstants
                                                                  .BASE_URL +
                                                              AppConstants
                                                                  .UPLOAD_URL +
                                                              getCartHistoryList[
                                                                      listCount -
                                                                          1]
                                                                  .img!),
                                                        ),
                                                      ),
                                                    )
                                                  : Container();
                                            }),
                                          ),
                                          SizedBox(
                                            height: Dimensions.height20 * 4,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SmallText(
                                                  text: "Total",
                                                  color: AppColors.titleColor,
                                                ),
                                                BigText(
                                                  text:
                                                      '${itemsPerOrder[i]} Items',
                                                  color: AppColors.titleColor,
                                                ),
                                                GestureDetector(
                                                  onTap: (() {
                                                    var orderTime =
                                                        cartOrderTimeToList();
                                                    Map<int, CartModel>
                                                        moreOrder = {};
                                                    for (var j = 0;
                                                        j <
                                                            getCartHistoryList
                                                                .length;
                                                        j++) {
                                                      // ignore: unrelated_type_equality_checks
                                                      if (getCartHistoryList[j]
                                                              .time ==
                                                          orderTime[i]) {
                                                        moreOrder.putIfAbsent(
                                                          getCartHistoryList[j]
                                                              .id!,
                                                          () => CartModel
                                                              .fromJson(
                                                            jsonDecode(
                                                              jsonEncode(
                                                                getCartHistoryList[
                                                                    j],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      Get.find<CartController>()
                                                          .setItems = moreOrder;
                                                      Get.find<CartController>()
                                                          .addToCartList();
                                                      Get.toNamed(RouteHelper
                                                          .getCartPage());
                                                    }
                                                  }),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                Dimensions
                                                                    .width10,
                                                            vertical: Dimensions
                                                                    .height10 /
                                                                2),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                    .radius15 /
                                                                3),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: AppColors
                                                                .mainColor)),
                                                    child: SmallText(
                                                      text: "one more",
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: const Center(
                        child: NoDataPage(
                            text: "You didn't buy anything so far !",
                            imgPath: 'assets/images/empty_box.jpg'),
                      ),
                    );
            })
          ],
        ));
  }
}
