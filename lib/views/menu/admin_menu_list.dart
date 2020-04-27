import 'package:awesome_project/views/menu/description_page.dart';
import 'package:awesome_project/views/menu/update_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../navbar/admin_bottom_navigation.dart';
import 'new_item.dart';

class MenuList extends StatefulWidget {

  final String title;

  MenuList({Key key, this.title}) : super(key : key);

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {

  void toAddItem(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Item(),
            fullscreenDialog: true
        )
    );
  }

  deleteData(snapshot, index) async {
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(snapshot.data.documents[index].reference);
    });
    _showDialog();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Confirmation"),
          content: new Text("Item Deleted"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.bars),
        ),
        title: Container(
          alignment: Alignment.center,
          child: Text("ABC Resturant", style: TextStyle()),
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
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
              image: AssetImage('assets/images/orderback.jpg'),
              fit: BoxFit.cover),
        ),
        child: StreamBuilder(
          stream: Firestore.instance.collection('post').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Text("Loading ... "),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot mypost = snapshot.data.documents[index];
                    String title = "";
                    title = mypost['title'];
                    return Stack(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.amber)
                                ),
                                child: new Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DescriptionPage(
                                                        id: title),
                                                fullscreenDialog: true
                                            )
                                        );
                                      },
                                      child: Text('${mypost['title']}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),

                                    Image.network('${mypost['image']}'),

                                    SizedBox(
                                      height: 8,
                                    ),

                                    Text('${mypost['subtitle']}',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18.0,
                                            fontStyle: FontStyle.italic
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 120.0, top: 10.00),
                                      child: FloatingActionButton.extended(
                                        heroTag: null,
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DescriptionPage(
                                                          id: title),
                                                  fullscreenDialog: true
                                              )
                                          );
                                        },
                                        label: Text('${mypost['price']}'),
                                        icon: Icon(Icons.attach_money),
                                        backgroundColor: Colors.amber,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(7.0),
                                        child: Row(
                                          children: <Widget>[

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 55.0, top: 10.00),
                                              child: FlatButton.icon(
                                                color: Colors.white,
                                                icon: Icon(
                                                    Icons.edit
                                                ),
                                                //
                                                textColor: Colors.blueAccent,
                                                // `Icon` to display
                                                label: Text(
                                                    'Edit'
                                                ),
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UpdateItem(
                                                                  id: title),
                                                          fullscreenDialog: true
                                                      )
                                                  );
                                                },
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 55.0, top: 10.00),
                                              child: FlatButton.icon(
                                                color: Colors.white,
                                                icon: Icon(
                                                    Icons.delete_forever
                                                ),
                                                //
                                                textColor: Colors.redAccent,
                                                // `Icon` to display
                                                label: Text(
                                                    'Delete'
                                                ),
                                                onPressed: () {
                                                  deleteData(snapshot, index);
                                                },
                                              ),
                                            ),


                                          ],
                                        )),


                                  ],
                                ),
                              )
                          ),
                        ),


                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  });
            }
          },
        ),
      ),





      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: (){
          toAddItem();
        },
        child: Icon(Icons.add,color: Colors.white),
        backgroundColor: Colors.blue[600],
      ),

      bottomNavigationBar: AdminBottomNavigation(input: 0),
    );
  }

}