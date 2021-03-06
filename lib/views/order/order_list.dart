///Student ID : IT17103732
///Name : Silva N.P.S
///Order list class to show all the placed orders

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  String uid;

  ///init the status
  @override
  void initState() {

    super.initState();
    loadUser();
  }

  ///load the logged user details from the database
  ///The id/key is needed to fetch the customer orders
  loadUser() async{
    ///fetch the user
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    setState(() {
      uid = user.uid;
    });
  }

  ///function to delete an selected order
  deleteOrder(snapshot, index, BuildContext context ) async {
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(snapshot.data.documents[index].reference);

      showToast(context, "Order deleted successfully !");
    });
  }


  ///Flutter build method
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.bars),
          onPressed: () {

          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: Text("My Orders", style: TextStyle()),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.hamburger),
            iconSize: 20.0,
            color: Colors.white,
            onPressed: null,
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
              image: AssetImage('assets/images/orderback.jpg'),
              fit: BoxFit.cover),
        ),
        child: StreamBuilder(
          stream: Firestore.instance.collection("user").document(uid).collection("order").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Text( "Loading ... "),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot order = snapshot.data.documents[index];
                    String title = "";
                    title = order['title'];
                    return Stack(
                      children: [


                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${order['orderDate']}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${order['orderTime']}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Rs. ${order['total']}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),

                                Spacer(),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    color: Colors.white,
                                    child: Icon(Icons.delete_forever),
                                    textColor: Colors.redAccent,// `Icon` to display
                                    onPressed: () {
                                      deleteOrder(snapshot, index, context );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 35,
                        )
                      ],
                    );
                  });
            }
          },
        ),

      ),

    );
  }

  ///function to display the snackbar with the message
  void showToast(BuildContext context, String message ) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(message),
        action: SnackBarAction(
            label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
