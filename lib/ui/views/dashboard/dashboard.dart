import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodie/ui/widgets/widgets.dart';
import 'package:foodie/utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DeviceUtil _deviceUtil;
  bool _isDrawerOpen = false;
  int _currentIndex = 0;

  Matrix4 _getContainerMatrix() {
    return Matrix4.identity()
      ..translate(220.0, _deviceUtil.screenHeight(extent: 0.13))
      ..scale(0.7);
  }

  Matrix4 _getEmptyContainerMatrix() {
    return Matrix4.identity()
      ..translate(195.0, _deviceUtil.screenHeight(extent: 0.19))
      ..scale(0.68);
  }

  @override
  Widget build(BuildContext context) {
    _deviceUtil = DeviceUtil(context);
    return Stack(
      children: [
        // ===== The Drawer widget =====
        _Drawer(),

        // ===== Transparent widget stacked behind the DashboardView =====
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: shadowColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          transform:
              _isDrawerOpen ? _getEmptyContainerMatrix() : Matrix4.identity(),
        ),

        // ===== Dashboard View =====
        GestureDetector(
          onTap: () => setState(
            () => _isDrawerOpen = false,
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            transform:
                _isDrawerOpen ? _getContainerMatrix() : Matrix4.identity(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: AbsorbPointer(
                absorbing: _isDrawerOpen ? true : false,
                child: Scaffold(
                  appBar: _currentIndex == 0
                      ? AppBar(
                          leading: Padding(
                            padding:
                                const EdgeInsets.only(left: horizontalPadding),
                            child: InkWell(
                              onTap: () {
                                setState(
                                  () => _isDrawerOpen = true,
                                );
                              },
                              highlightColor: transparentColor,
                              splashColor: transparentColor,
                              child: ImageIcon(
                                AssetImage(
                                  FoodieAssets.menu,
                                ),
                                color: blackColor,
                              ),
                            ),
                          ),
                          backgroundColor: transparentColor,
                          elevation: 0.0,
                          actions: [
                            Padding(
                              padding:
                                  EdgeInsets.only(right: horizontalPadding),
                              child: ImageIcon(
                                AssetImage(
                                  FoodieAssets.shoppingCart,
                                ),
                                color: blackColor,
                              ),
                            ),
                          ],
                          brightness: _isDrawerOpen
                              ? Brightness.dark
                              : Brightness.light,
                        )
                      : null,
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(
                        () {
                          if (index != 0)
                            Navigator.pushNamed(
                              context,
                              bottomNavRoutes[index],
                            );
                        },
                      );
                    },
                    type: BottomNavigationBarType.fixed,
                    elevation: 0.0,
                    backgroundColor: bgColor,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    items: [
                      ...List.generate(
                        bottomNavWidgets.length,
                        (index) => BottomNavigationBarItem(
                          icon: Image.asset(
                            bottomNavAssets[index],
                          ),
                          label: bottomNavTitle[index],
                        ),
                      ),
                    ],
                  ),
                  body: bottomNavWidgets.elementAt(_currentIndex),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding / 2,
        ).add(
          EdgeInsets.only(
            top: verticalPadding * 2,
          ),
        ),
        children: [
          ...List.generate(
            drawerItems.length,
            (index) {
              return Column(
                children: [
                  _DrawerEntry(
                    index: index,
                  ),
                  if (index != drawerItems.length - 1)
                    Divider(
                      color: bgColor,
                      height: 15,
                      endIndent: 170,
                      indent: 10,
                    ),
                  if (index == drawerItems.length - 1) YBox(100),
                  if (index == drawerItems.length - 1)
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              FoodieStrings.signOut,
                              style: TextStyle(
                                fontSize: 16,
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            XBox(5),
                            Icon(
                              Icons.arrow_forward,
                              color: whiteColor,
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class _DrawerEntry extends StatelessWidget {
  final int index;

  const _DrawerEntry({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        _getAsset(
          index,
        ),
      ),
      title: Transform.translate(
        offset: Offset(-20, 0),
        child: Text(
          drawerItems.elementAt(
            index,
          ),
          style: TextStyle(
            fontSize: 14,
            color: whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getAsset(int index) {
    switch (index) {
      case 0:
        return FoodieAssets.profile;
      case 1:
        return FoodieAssets.orders;
      case 2:
        return FoodieAssets.offerAndPromo;
      case 3:
        return FoodieAssets.privacyPolicy;
      case 4:
        return FoodieAssets.security;
      default:
        return null;
    }
  }
}
