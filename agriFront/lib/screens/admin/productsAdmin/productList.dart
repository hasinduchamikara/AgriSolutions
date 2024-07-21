import 'package:agrifront/models/product.model.dart';
import 'package:agrifront/screens/admin/productsAdmin/inserProduct.dart';
import 'package:agrifront/screens/admin/productsAdmin/updateProduct.dart';
import 'package:agrifront/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../componets/navigationdrawer.dart';
import '../../../utils/confirmDialog.dart';

class ProdcutsView extends StatefulWidget {
  ProdcutsView({Key? key}) : super(key: key);

  // final String title;
  final ProductsService productsService = ProductsService();
  // final ProjectService projectService = new ProjectService();

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProdcutsView> {
  List<ProductModel> issues = [];

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Future<void> _getProducts() async {
    widget.productsService.getAll().then((value) => {
          setState(() {
            issues = value;
          })
        });
  }

  void _createIssues() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProductCreatePage()),
    );
    _getProducts();
  }

  void _editeIssues(ProductModel product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ProductEditPage(product: product)),
    );
    _getProducts();
  }

  void _deleteIssues(ProductModel product) {
    ConfirmDialog.show(
      context,
      'Are you sure you want to delete?',
      () => ({
        widget.productsService
            .deleteProduct(product)
            .then((value) => {
                  Fluttertoast.showToast(
                      msg: 'Successfully Deleted',
                      toastLength: Toast.LENGTH_LONG,
                      fontSize: 20,
                      backgroundColor: Colors.green),
                  _getProducts()
                })
            .catchError((e) => {print(e.toString())})
      }),
    );
  }

  // bool _canDelete(ProductModel product) {
  //   for (var project in projects) {
  //     if (project.responsible.email == product.email) return false;
  //   }
  //   return true;
  // }

  // void _getProjects() {
  //   widget.projectService.getAll().then((value) => {
  //         setState(() {
  //           projects = value;
  //         })
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NevigationDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 5, 156, 10),
          title: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Products",
              style: TextStyle(
                  fontSize: 24.0, color: Color.fromARGB(215, 255, 255, 255)),
            ),
          ),
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 247, 213, 255)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 207, 54, 54),
          image: DecorationImage(
              image: AssetImage('assets/images/background2.jpg'),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: LiquidPullToRefresh(
            color: Color.fromARGB(255, 69, 231, 88),
            onRefresh: _getProducts,
            child: ListView(
              padding: const EdgeInsets.all(25.0),
              scrollDirection: Axis.vertical,
              children: issues
                  .map((data) => Card(
                        color: Color.fromARGB(255, 175, 238, 139),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage('${data.imageUrl}')),
                          title: Text(data.title.toString()),
                          subtitle: Text("Price: " + data.price.toString()),
                          trailing: PopupMenuButton(
                            onSelected: (option) {
                              if (option == 'edit') {
                                _editeIssues(data);
                              } else {
                                _deleteIssues(data);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(children: const [
                                  Icon(Icons.edit),
                                  SizedBox(width: 10),
                                  Text('Edit'),
                                ]),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(children: const [
                                  Icon(Icons.delete),
                                  SizedBox(width: 10),
                                  Text('Delete'),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createIssues();
        },
        tooltip: 'Insert Product',
        child: const Icon(Icons.add),
        backgroundColor: Color.fromARGB(246, 88, 220, 76),
      ),
    );
  }
}
