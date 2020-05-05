import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/auth.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/components.dart';
import 'package:shop_app/reusables/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    //print(user);
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0,
        backgroundColor: kbackgroundColor,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: StreamBuilder(
        stream: DatabaseServices().streamUser(user),
        builder: (context, snap) {
          if (snap.hasData) {
            return _buildUserForm(snap.data);
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildUserForm(User user) {
    
        return SingleChildScrollView(
          child: Column(
            // TODO UI
    
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Stack(fit: StackFit.loose, children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kbackgroundColor,
                          boxShadow: [
                            BoxShadow(
                                color: kshadowColor,
                                offset: Offset(8, 6),
                                blurRadius: 12),
                            BoxShadow(
                                color: klightShadowColor,
                                offset: Offset(-8, -6),
                                blurRadius: 12),
                          ],
                        ),
                        child: CircleAvatar(
                          child: Icon(
                            CupertinoIcons.person_add_solid,
                            color: Colors.white,
                            size: 100,
                          ),
                          backgroundColor: kbackgroundColor ?? Colors.grey[200],
                          radius: 70,
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 90.0, left: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.orange,
                            radius: 25.0,
                            child: Icon(
                              CupertinoIcons.photo_camera,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )),
                ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: kSoftShadowDecoration.copyWith(
                    borderRadius: BorderRadius.circular(30)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextField(
                    decoration: kInputDecoration.copyWith(
                      fillColor: kbackgroundColor,
                      prefixIcon: Icon(CupertinoIcons.person),
                      hintText: user.name,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: kSoftShadowDecoration.copyWith(
                    borderRadius: BorderRadius.circular(30)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextField(
                    decoration: kInputDecoration.copyWith(
                      fillColor: kbackgroundColor,
                      prefixIcon: Icon(CupertinoIcons.phone),
                      hintText: user.phone,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: kSoftShadowDecoration.copyWith(
                    borderRadius: BorderRadius.circular(30)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextField(
                    decoration: kInputDecoration.copyWith(
                      fillColor: kbackgroundColor,
                      prefixIcon: Icon(CupertinoIcons.phone_solid),
                      hintText: user.alternatePhoneNumber,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: kSoftShadowDecoration.copyWith(
                    borderRadius: BorderRadius.circular(30)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextField(
                    decoration: kInputDecoration.copyWith(
                      fillColor: kbackgroundColor,
                      prefixIcon: Icon(CupertinoIcons.location),
                      hintText: user.address,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  shape: BoxShape.rectangle,
                  color: kbackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: kshadowColor, offset: Offset(8, 6), blurRadius: 12),
                    BoxShadow(
                        color: klightShadowColor,
                        offset: Offset(-8, -6),
                        blurRadius: 12),
                  ],
                ),
                child: Buttons(
                
              iconColor: Colors.green,
              textColor: Colors.green,
              buttonColor: kbackgroundColor,
              text: "Update Profile",
              icon: Icons.refresh,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              shape: BoxShape.rectangle,
              color: kbackgroundColor,
              boxShadow: [
                BoxShadow(
                    color: kshadowColor, offset: Offset(8, 6), blurRadius: 12),
                BoxShadow(
                    color: klightShadowColor,
                    offset: Offset(-8, -6),
                    blurRadius: 12),
              ],
            ),
            child: Buttons(
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              buttonColor: kbackgroundColor ?? Colors.red,
              text: "Logout",
              icon: Icons.exit_to_app,
              onTap: () {
                Navigator.pop(context);
                AuthServices().signOut();
              },
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
