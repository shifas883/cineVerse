import 'package:cineVerse/common_widgets/button.dart';
import 'package:cineVerse/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../cache/save_user_data.dart';
import '../models/model_class.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LoginResponse? loginData;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final data = await getLoginData(); // Fetch the saved data
    setState(() {
      loginData = data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
             ProfilePic(image: loginData?.image ?? ''),
            Text(
              "${loginData?.firstName?.toString()} ${loginData?.lastName?.toString()}" ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 16.0 * 2),
             Info(
              infoKey: "User Name",
              info: "${loginData?.username?.toString() ?? ''}",
            ),
             Info(
              infoKey: "Gender",
              info: loginData?.gender ?? '',
            ),
             Info(
              infoKey: "Email Address",
              info: loginData?.email ?? '',
            ),
            const SizedBox(height: 100.0),
            Container(
              width: 200,
                child: ConfirmButton(text: "Logout", onTap: () {
                  clearLoginData();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()), // Replace with your login screen
                        (route) => false, // Clear the back stack
                  );
                }))
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
          Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(image),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.infoKey,
    required this.info,
  });

  final String infoKey, info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            infoKey,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.8),
            ),
          ),
          Text(info),
        ],
      ),
    );
  }
}
