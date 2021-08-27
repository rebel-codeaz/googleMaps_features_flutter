import 'package:flutter/material.dart';

class SearchPlaces extends StatefulWidget {
  const SearchPlaces({ Key? key }) : super(key: key);

  @override
  _SearchPlacesState createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {
 final _controller = TextEditingController();
 
   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            onTap: () async {
             // placeholder for our places search later
              showSearch(
                context: context,
                // we haven't created AddressSearch class
                // this should be extending SearchDelegate
                delegate: AddressSearch(),
              );
            },
            // with some styling
            decoration: InputDecoration(
              icon: Container(
                margin: EdgeInsets.only(left: 20),
                width: 10,
                height: 10,
                child: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
              ),
              hintText: "Enter your shipping address",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}