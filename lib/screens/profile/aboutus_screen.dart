import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack,
        centerTitle: true,
        title: Text(
          "About-us",
          style: TextStyle(
            color: customWhite,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Text(
                            "About TechStuff",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 70,
                            height: 4,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Welcome to our online store for computer accessories! We are a team of dedicated professionals who are passionate about technology and are committed to providing customers with high-quality products and exceptional service.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                              // color: Colors.black87,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Card(
                //   elevation: 5,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 20),
                //     child: SizedBox(
                //       width: double.infinity,
                //       child: Column(
                //         children: [
                //           const Text(
                //             "Our Team",
                //             style: TextStyle(
                //               fontSize: 20,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           ),
                //           const SizedBox(height: 5),
                //           Container(
                //             width: 40,
                //             height: 4,
                //             color: Colors.red,
                //           ),
                //           const SizedBox(height: 20),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //             children: [
                //               InkWell(
                //                 onTap: () {
                //                   _launchUrl(
                //                       'https://www.instagram.com/soham_kolhe_05/');
                //                 },
                //                 child: Column(
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: BorderRadius.circular(50),
                //                       child: Image.network(
                //                         width: 60,
                //                         height: 60,
                //                         "https://www.vippng.com/png/detail/8-87352_free-high-quality-person-icon-icon.png",
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                     const Text(
                //                       "Soham Kolhe",
                //                       style: TextStyle(
                //                         fontSize: 15,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     ),
                //                     const Text(
                //                       "App Developer",
                //                       style: TextStyle(
                //                         color: Colors.grey,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               InkWell(
                //                 onTap: () {
                //                   _launchUrl(
                //                       'https://www.instagram.com/ya_sh_in_g_le/');
                //                 },
                //                 child: Column(
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: BorderRadius.circular(50),
                //                       child: Image.network(
                //                         width: 60,
                //                         height: 60,
                //                         "https://www.vippng.com/png/detail/8-87352_free-high-quality-person-icon-icon.png",
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                     const Text(
                //                       "Raju Katare",
                //                       style: TextStyle(
                //                         fontSize: 15,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     ),
                //                     const Text(
                //                       "UI Designer",
                //                       style: TextStyle(
                //                         color: Colors.grey,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               InkWell(
                //                 onTap: () {
                //                   _launchUrl(
                //                       'https://www.instagram.com/_abhishek_wani_/');
                //                 },
                //                 child: Column(
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: BorderRadius.circular(50),
                //                       child: Image.network(
                //                         width: 60,
                //                         height: 60,
                //                         "https://www.vippng.com/png/detail/8-87352_free-high-quality-person-icon-icon.png",
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                     const Text(
                //                       "Abhishek Wani",
                //                       style: TextStyle(
                //                         fontSize: 15,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     ),
                //                     const Text(
                //                       "Web Developer",
                //                       style: TextStyle(
                //                         color: Colors.grey,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Text(
                            "Mission",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 40,
                            height: 4,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Our mission is to provide a convenient and user-friendly platform for customers to purchase high-quality computer accessories at competitive prices. We strive to offer a wide variety of products that cater to different needs and preferences, while ensuring that all items meet our rigorous standards for performance, durability, and reliability.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                              // color: Colors.black87,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _launchUrl(
                        'https://www.google.co.in/maps/place/Thakur+Shivkumarsingh+Memorial+Engineering+College/@21.3907601,76.2607538,17z/data=!3m1!4b1!4m6!3m5!1s0x3bd8321ad3ffffff:0xe29f11a5965abf76!8m2!3d21.3907551!4d76.2629478!16s%2Fg%2F11b7ytvbn4');
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Text(
                              "Address",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 40,
                              height: 4,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "📍 Thakur Shivkumarsingh Memorial Polytechnic Collage Zhiri Dist. Burhanpur Madhya Pradesh",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 18,
                                // color: Colors.black87,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String uri) async {
    final Uri _url = Uri.parse(uri);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
