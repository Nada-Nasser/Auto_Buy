import 'package:auto_buy/screens/friends/friends_screen.dart';
import 'package:auto_buy/screens/my_orders/my_orders_screen.dart';
import 'package:auto_buy/screens/user_account/help_support.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/firebase_backend/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'User_Settings.dart';
import 'constants.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);

    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    var profileInfo = Expanded(
      child: StreamBuilder(
            stream: CloudFirestoreService.instance.documentStream(
                path: "users/${auth.uid}",
                builder: (Map<String, dynamic> data, String documentId) {
                  return data;
                }),
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            return Column(
              children: [
                Container(
                  height: kSpacingUnit.w * 10,
                  width: kSpacingUnit.w * 10,
                  margin: EdgeInsets.only(top: kSpacingUnit.w * 1),
                  child: Stack(
                    children: [
                      FutureBuilder(
                        future: FirebaseStorageService.instance
                            .downloadURL(snapShot.data['pic_path']),
                        builder: (ctx, image) {
                          if (image.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }else{
                            String pth;
                            if (snapShot.data['pic_path']
                                .toString()
                                .contains('googleusercontent')) {
                              pth = snapShot.data['pic_path'];
                            } else {
                              pth = image.data;
                            }
                            return CircleAvatar(
                              radius: kSpacingUnit.w * 5,
                              backgroundImage:
                              NetworkImage(pth),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kSpacingUnit.w * 2),
                Text(snapShot.data['name'], style: kTitleTextStyle),
                SizedBox(height: kSpacingUnit.w * 0.5),
                SelectableText(' '+snapShot.data['id'], style: kCaptionTextStyle),
                SizedBox(height: kSpacingUnit.w * 2),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        profileInfo,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.arrow_left,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3)),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          header,
          Expanded(
            child: ListView(
              children: <Widget>[
                ProfileListItem(
                  icon: LineAwesomeIcons.user,
                  text: 'My Account',
                  Navigate_To: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                  },
                ),
                // ProfileListItem(
                //   icon: LineAwesomeIcons.history,
                //   text: 'Purchase History',
                //   Navigate_To: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         fullscreenDialog: true,
                //         builder: (context) => MyOrdersScreen(),
                //       ),
                //     );
                //   },
                // ),
                ProfileListItem(
                  icon: LineAwesomeIcons.user_friends,
                  text: 'Friends',
                  Navigate_To: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AllScreens(),
                      ),
                    );
                  },
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.question_circle,
                  text: 'Help & Support',
                  Navigate_To: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => Support(),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final text;
  final bool hasNavigation;
  final Function Navigate_To;
  const ProfileListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
    this.Navigate_To,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kSpacingUnit.w * 5.5,
      margin: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.w * 4,
      ).copyWith(
        bottom: kSpacingUnit.w * 2,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.w * 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            this.icon,
            size: kSpacingUnit.w * 2.5,
          ),
          SizedBox(width: kSpacingUnit.w * 2.5),
          Text(
            this.text,
            style: kTitleTextStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              LineAwesomeIcons.angle_right,
            ),
          onPressed: Navigate_To
          ),
        ],
      ),
    );
  }
}
