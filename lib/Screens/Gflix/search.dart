import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/toprated.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/trending.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/tv.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/upcoming.dart';
import 'package:flutter_auth/Screens/Login/components/facebook_login_controller.dart';
import 'package:flutter_auth/Screens/Login/components/google_sign_in.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:flutter_auth/Screens/Gflix/Description/description.dart';

void main() => runApp(new MaterialApp(
  home: new SearchListExample(),
));

class SearchListExample extends StatefulWidget {
  @override
  _SearchListExampleState createState() => new _SearchListExampleState();
}

class _SearchListExampleState extends State<SearchListExample> {
  Widget appBarTitle = new Text(
    "Search Example",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  //List<dynamic> _list;
  bool _isSearching;
  String _searchText = "";
  //List searchresult = new List();

  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODg3MmQ2NDFlNDdiY2YwMWU4YjQ3Yzc1ZTAyMDYyMyIsInN1YiI6IjYxM2U3ZTVjOTE3NDViMDA5MWU3OGI5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.q-bvvinn7hwRIRHRRQtfgQRWsbhITyfALcho9Y8zhJk';
  List searchresult = [];

  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    _isSearching = false;
    super.initState();
    //loadmovies();
  }

    //Map trendingresult = await tmdbWithCustomLogs.v3.trending.getTrending();

  _SearchListExampleState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }


  /* void values() {
    _list = List();
    _list.add("Indian rupee");
    _list.add("United States dollar");
    _list.add("Australian dollar");
    _list.add("Euro");
    _list.add("British pound");
    _list.add("Yemeni rial");
    _list.add("Japanese yen");
    _list.add("Hong Kong dollar");
  } */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar: buildAppBar(context),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Flexible(
                  child: searchresult != null || searchresult.length != 0 || _controller.text.isNotEmpty
                      ? new ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchresult.length,
                        itemBuilder: (BuildContext context, int index) { //probably the result UI idk
                          //searchresult[index]['title'] == null ? searchresult[index]['name'] : searchresult[index]['title'],
                          String listData = searchresult[index]['title'] == null ? searchresult[index]['name'] : searchresult[index]['title'];
                          print(searchresult[index]);
                          return new ListTile(
                            title: new Text(listData.toString(), style: TextStyle(color: Colors.white,),  ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new Description(
                                        id: searchresult[index]['id'],
                                        name: searchresult[index]['title'] == null
                                            ? searchresult[index]['name']
                                            : searchresult[index]['title'],
                                        bannerurl: searchresult[index]
                                        ['backdrop_path'] ==
                                            null
                                            ? 'empty'
                                            : 'https://image.tmdb.org/t/p/w500' +
                                            searchresult[index]['backdrop_path'],
                                        posterurl: searchresult[index]
                                        ['poster_path'] ==
                                            null
                                            ? 'empty'
                                            : 'https://image.tmdb.org/t/p/w500' +
                                            searchresult[index]['poster_path'],
                                        description: searchresult[index]['overview'],
                                        vote: searchresult[index]['vote_average']
                                            .toString(),
                                        launchOn: searchresult[index]
                                        ['release_date'] ==
                                            null
                                            ? searchresult[index]['first_air_date']
                                            : searchresult[index]['release_date'],
                                        mediaType: searchresult[index]['media_type'],
                                      )));
                            },
                      );
                    },
                  )
                      : new CircularProgressIndicator(),
              )
            ],
          ),
        ));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Sample",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) async {
    searchresult.clear();
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    Map searchresult1 = await tmdbWithCustomLogs.v3.search.queryMovies(searchText);
    Map searchresult2 = await tmdbWithCustomLogs.v3.search.queryTvShows(searchText);// queryMulti( searchText );
    setState(() {
      searchresult = searchresult1['results'] + searchresult2['results'];
    });
  }
}

