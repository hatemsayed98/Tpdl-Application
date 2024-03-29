import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_version_01/Controller/itemController.dart';
import 'package:gp_version_01/Controller/offerController.dart';
import 'package:gp_version_01/Screens/favorites_screen.dart';
import 'package:gp_version_01/Screens/myProducts_screen.dart';
import 'package:gp_version_01/Screens/recommend_screen.dart';
import 'package:gp_version_01/widgets/Grid.dart';
import 'package:gp_version_01/widgets/text_field_search.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';
import 'chooseCategory_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "Home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List categories = [
    "اخري",
    "موبايلات",
    "ملابس",
    "كتب",
    "عربيات",
    "خدمات",
    "حيوانات",
    "ألعاب إلكترونية",
    "أجهزة كهربائية",
    "أثاث منزل",
    "الكل",
  ];

  bool isLeave = false;
  bool isInit = true;
  bool isLoading = true;
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget continueButton = FlatButton(
      child: Text("لا"),
      onPressed: () {
        isLeave = false;
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("نعم"),
      onPressed: () {
        isLeave = true;
        Navigator.of(context).pop();
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
    );

    // set up the AlertDialog
    Directionality alert = Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text("تنبيه"),
          content: Text("هل انت متأكد انك تريد الخروج من البرنامج؟"),
          actions: [
            cancelButton,
            continueButton,
          ],
        ));

    // show the dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ItemController>(context)
          .getItems()
          .then((value) => setState(() {
                isLoading = false;
              }));
      Provider.of<ItemOffersController>(context).getAllOffers();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    Provider.of<ItemController>(context).getUserHomeItems();
    final items = Provider.of<ItemController>(context).userHomeItems;
    return DefaultTabController(
      initialIndex: categories.length - 1,
      length: categories.length,
      child: WillPopScope(
        onWillPop: () async {
          showAlertDialog(context);
          return isLeave;
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                endDrawer: DrawerItem(),
                appBar: AppBar(
                   title:TextFieldSearch(items, false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  toolbarHeight: 100,
                  leading:
                      IconButton(icon: Icon(Icons.search), onPressed: () {}),
                  bottom: PreferredSize(
                    preferredSize: Size(0, 10),
                    child: Container(
                      child: TabBar(
                          isScrollable: true,
                          tabs: categories
                              .map((e) => Text(
                                    e,
                                    style: GoogleFonts.cairo(),
                                  ))
                              .toList()),
                    ),
                  ),
                ),
                body: Container(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('اخري')),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('موبايلات')),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('ملابس')),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('كتب')),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('عربيات')),
                          ),
                        ],
                      ),
                      Column(children: [
                        Expanded(
                          child: Grid(
                              items: Provider.of<ItemController>(context)
                                  .getCategoryItems('خدمات')),
                        )
                      ]),
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('حيوانات')),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('ألعاب إلكترونية')),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('أجهزة كهربائية')),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Grid(
                                items: Provider.of<ItemController>(context)
                                    .getCategoryItems('أثاث منزل')),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            ChooseCategoryScreen.route);
                                      },
                                      child: Icon(
                                        Icons.category_outlined,
                                        color: Colors.blue[400],
                                        size: 40,
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, Favorites.route);
                                      },
                                      child: Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.blue[400],
                                        size: 40,
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, Recommend.route);
                                      },
                                      child: Icon(
                                        Icons.recommend,
                                        color: Colors.blue[400],
                                        size: 40,
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, MyProducts.route);
                                      },
                                      child: Icon(
                                        Icons.business_center_outlined,
                                        color: Colors.blue[400],
                                        size: 40,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    'الفئات',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'المفضلة',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'مقترح',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'منتجاتى',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Grid(items: items),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
