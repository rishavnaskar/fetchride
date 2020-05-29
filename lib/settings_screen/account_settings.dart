import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  AccountSettings(
      {this.photoUrl,
      this.displayName,
      this.email,
      this.password,
      this.phoneNumber});
  final String email, photoUrl, phoneNumber, displayName, password;
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 8,
            leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 30.0),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Account Settings',
                      style: TextStyle(fontFamily: 'Montserrat'))),
              background: Container(color: Colors.black),
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
            ),
            floating: true,
            pinned: true,
            snap: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  CircleAvatar(
                    maxRadius: 60.0,
                    minRadius: 20.0,
                    backgroundImage: widget.photoUrl == null
                        ? AssetImage('assets/image4.png')
                        : NetworkImage('${widget.photoUrl}'),
                    backgroundColor: Colors.black,
                  ),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
