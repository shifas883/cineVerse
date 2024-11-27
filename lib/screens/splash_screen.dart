import 'package:cineVerse/common_widgets/button.dart';
import 'package:cineVerse/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to CineVerse, Let’s explore the world of movies!",
      "image": "https://img.freepik.com/free-vector/video-upload-concept-illustration_114360-6773.jpg?t=st=1732616967~exp=1732620567~hmac=888f329b7ffe188bb4741f54923312f8dc91b819b0fa928bf865d44bd355e44b&w=740"
    },
    {
      "text":
      "We bring your favorite movies and shows\nright to your screen, anytime, anywhere.",
      "image": "https://img.freepik.com/free-vector/landscape-mode-concept-illustration_114360-8356.jpg?t=st=1732617005~exp=1732620605~hmac=b58995bc83bea57c69fdd9f619e33b01a4f03105dc21866002f977023e664774&w=740"
    },
    {
      "text": "We make streaming simple. \nRelax at home and enjoy with us.",
      "image": "https://img.freepik.com/free-vector/media-player-concept-illustration_114360-2852.jpg?t=st=1732617097~exp=1732620697~hmac=3419e12c5a7ee4672c7f6b60f1eb681f93a5ca8024c739abd6b6c802234ecf2c&w=740"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                    text: splashData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 5),
                            height: 6,
                            width: currentPage == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? const Color(0xFFFF7643)
                                  : const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      ConfirmButton(text: "Continue", onTap: (){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );

                      }),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashContent extends StatefulWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        const Text(
          "CineVerse",
          style: TextStyle(
            fontSize: 32,
            color: Color(0xFFFF7643),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.network(
          widget.image!,
          fit: BoxFit.contain,
          height: 265,
          width: 235,
        ),
      ],
    );
  }
}
