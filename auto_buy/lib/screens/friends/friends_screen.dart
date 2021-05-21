import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

class AllScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Colors.white,
              tabs: [Tab(text: 'My Friends'), Tab(text: 'Requests')],
            ),
            title: Text('Friends', style: TextStyle(color: Colors.white)),
            elevation: 0.1,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  /* will be added later */
                },
              ),
              IconButton(
                icon: Icon(
                  LineAwesomeIcons.user_plus,
                  color: Colors.white,
                ),
                onPressed: () {
                  /* will be added later */
                },
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: TabBarView(
            children: [FriendList(), RequestList()],
          ),
        ),
      ),
    );
  }
}

class RequestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
                child: Text(
          'Second Activity Screen',
          style: TextStyle(fontSize: 21),
        ))));
  }
}

class FriendList extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FriendList> {
  Future fetchPhotos() async {
    var res = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    if (res.statusCode == 200) {
      var obj = json.decode(res.body);
      return obj;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: Center(
            child: FutureBuilder(
                future: fetchPhotos(),
                builder: (ctx, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView.builder(itemBuilder: (_, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        key: ValueKey(snapShot.data[index]['title']),
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.orange[200]),
                                ),
                              ),
                              child: Hero(
                                tag: "avatar_" + snapShot.data[index]['title'],
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundImage: NetworkImage(
                                      snapShot.data[index]['thumbnailUrl']),
                                ),
                              ),
                            ),
                            title: Text(
                              snapShot.data[index]['title'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                new Flexible(
                                    child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "${snapShot.data[index]['id']}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      maxLines: 3,
                                      softWrap: true,
                                    )
                                  ],
                                ))
                              ],
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.black, size: 30.0),
                            onTap: () {},
                          ),
                        ),
                      );
                    });
                  }
                }),
          ),
        ));
  }
}
