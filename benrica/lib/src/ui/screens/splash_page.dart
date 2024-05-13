import 'dart:async';

import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/domain/ultis/api_url.dart';
import 'package:benrica/src/domain/ultis/shared_preferences_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  CompanyModel? company;
  String baseUrlImg = '${ApiUrl.URL_IMAGE}businesses/';

  @override
  void initState() {
    super.initState();
    getCompanySelected();
  }

  Future<void> getCompanySelected() async {
    try {
      company = await SharedPreferencesHelper.getData<CompanyModel>(
        'company',
        (json) => CompanyModel.fromMap(json),
      );

      if (company != null && company?.logo_img != null) {
        setState(() {
          baseUrlImg += company?.logo_img ?? '';
        });
        print('Empresa recuperada: ${company!.business_name}');
        print('Empresa baseUrlImg: ${baseUrlImg}');

        Timer(const Duration(seconds: 5), () {
          context.pushReplacement('/login');
        });
      } else {
        context.pop();
      }
    } catch (e) {
      print(e);
    }
  }

  redirectApp(String type) {}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 16.0),
          child: company != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: baseUrlImg,
                        width: 200,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/logo/benrica_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Image.network(
                      //   baseUrlImg,
                      //   fit: BoxFit.cover,
                      //   errorBuilder: (context, error, stackTrace) {
                      //     // Handle image loading errors here
                      //     return Image.asset(
                      //       'assets/logo/benrica_logo.png',
                      //       fit: BoxFit.cover,
                      //     );
                      //   },
                      // ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                redirectApp('whatsapp');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Image(
                                  height: 30.0,
                                  image:
                                      AssetImage('assets/icons/whatsapp.png'),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                redirectApp('facebook');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Image(
                                  height: 30.0,
                                  image:
                                      AssetImage('assets/icons/facebook.png'),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                redirectApp('instagram');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Image(
                                  height: 30.0,
                                  image:
                                      AssetImage('assets/icons/instagram.png'),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                redirectApp('tiktok');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Image(
                                  height: 30.0,
                                  image: AssetImage('assets/icons/tiktok.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        const Column(children: [
                          Text(
                            'Desenvolvido por',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5),
                          Image(
                            height: 50,
                            image: AssetImage('assets/logo/benrica_logo.png'),
                          ),
                        ]),
                      ],
                    )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
