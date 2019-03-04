import 'package:flutter/material.dart';
import '../models/data-service.dart';
import 'feedByTag.dart';

class SearchFeedByTag extends StatefulWidget {
  SearchFeedByTag();

  @override
  _SearchFeedByTag createState() => _SearchFeedByTag();
}

class _SearchFeedByTag extends State<SearchFeedByTag> {
  bool _loading;

  Widget appBarTitle = Text(
    "Search by HashTags",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  List<String> _list;
  bool _isSearching;
  String _searchText = "";

  _SearchFeedByTag() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    _list = List<String>();
    _loading = false;
    _isSearching = false;
    dataService.getAllTags().then((list) {
      setState(() {
        _list = list;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: key,
          appBar: buildBar(context),
          body: _buildBody(),
        ),
        _showLoading(),
      ],
    );
  }

  Widget _showLoading() {
    return _loading
        ? Container(
            color: Colors.black.withOpacity(0.50),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SizedBox(
            height: 0.0,
            width: 0.0,
          );
  }

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: _isSearching ? _buildSearchList() : _buildList(),
    );
  }

  _buildList() {
    if (_list.length > 0)
      return _list.map((contact) => ChildItem(contact)).toList();
    else
      ListTile(
        title: Text("Loading...."),
      );
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => ChildItem(contact)).toList();
    } else {
      List<String> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => ChildItem(contact)).toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return AppBar(centerTitle: false, title: appBarTitle, actions: <Widget>[
      IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = TextField(
                controller: _searchQuery,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white)),
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
      this.actionIcon = Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        "Search by HashTags",
        style: TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}

class ChildItem extends StatelessWidget {
  final String name;
  ChildItem(this.name);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("#" + name),
      onTap: () => _showResult(context),
    );
  }

  _showResult(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedByTag(tag: name),
      ),
    );
  }
}
