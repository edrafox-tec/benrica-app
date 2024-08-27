import 'dart:convert';

import 'package:benrica/src/domain/APIs/api_routes_url.dart';
import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/domain/models/login_model.dart';
import 'package:benrica/src/domain/models/user_model.dart';
import 'package:benrica/src/domain/services/shared_preferences_service.dart';
import 'package:benrica/src/ui/screens/edit_user_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

enum SocialMediaType {
  WhatsApp,
  Instagram,
  Facebook,
  TikTok,
  // Adicione outros tipos de mídia social conforme necessário
}

class SettingsPage extends StatefulWidget {
  final ApiUrl apiUrl = ApiUrl();

  SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserResponseInterface? user;
  CompanyModel? company;
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final loginResponseJson =
        await _sharedPreferencesService.getSharedData('loginResponse');

    if (loginResponseJson == null) {
      user = UserResponseInterface.empty();
    } else {
      final Map<String, dynamic> jsonMap = jsonDecode(loginResponseJson);
      final loginResponse = LoginModel.fromMap(jsonMap);

      user = loginResponse.user;
      company = loginResponse.businesses;
    }
    setState(() {});
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Tem certeza que deseja sair?',
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              onPressed: () {
                context.pop();
                logout();
              },
            ),
          ],
        );
      },
    );
  }

  void logout() {
    context.pushReplacement('/login');
    // context.read<AuthService>().logout();
  }

  Future<void> openModalEditUser(
      BuildContext context, UserResponseInterface user) async {
    final returnedData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EditUserPage(user: user),
      ),
    );
    if (returnedData != null) {
      // schedules.getSchedule(context).then((_) {
      //   // print(schedules.state);
      //   // print(schedules.state.value);
      // });
    }
  }

  Widget buildUserInfo() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFF474545),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.user_name ?? ''),
            Text(user?.email ?? ''),
          ],
        ),
      ],
    );
  }

  Widget buildSettingsCard(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  Widget buildInfoText(String text, {TextStyle? style}) {
    return Text(
      text,
      style: style,
    );
  }

  Widget buildSocialMediaItem(String imageAsset, String buildInfoToText,
      String url, SocialMediaType type) {
    return InkWell(
      onTap: () async {
        await _handleTap(url, type);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
              child: Image.asset(
                imageAsset,
                height: 30.0,
              ),
            ),
          ),
          buildInfoText(
            buildInfoToText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTap(String? url, SocialMediaType type) async {
    if (url != null && url.isNotEmpty) {
      switch (type) {
        case SocialMediaType.WhatsApp:
          await _openWhatsApp(url);
          break;
        case SocialMediaType.Instagram:
          await _openInstagram(url);
          break;
        case SocialMediaType.Facebook:
          await _openFacebook(url);
          break;
        case SocialMediaType.TikTok:
          await _openTikTok(url);
          break;
        // Adicione casos para outros tipos de mídia social conforme necessário
      }
    } else {
      throw 'URL is empty or null';
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    await url_launcher
        .launch("https://api.whatsapp.com/send?phone=$phoneNumber");
  }

  Future<void> _openInstagram(String url) async {
    await url_launcher.launch(url);
  }

  Future<void> _openFacebook(String url) async {
    await url_launcher.launch(url);
  }

  Future<void> _openTikTok(String url) async {
    await url_launcher.launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            onPressed: () {
              showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configurações',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              if (user != null) const SizedBox(height: 30.0),
              buildSettingsCard('Meus dados', () {
                openModalEditUser(context, user!);
              }),
              buildSettingsCard('Trocar senha', () {
                context.push('/change-password');
              }),
              const SizedBox(height: 20.0),
              const Text(
                'Informações',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              buildInfoText(
                'Política de privacidade',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              buildInfoText(
                'Termos de uso',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Redes sociais',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              company?.phone != null
                  ? buildSocialMediaItem('assets/icons/whatsapp.png',
                      'WhatsApp', company!.phone, SocialMediaType.WhatsApp)
                  : const SizedBox(),
              company?.instagram != null
                  ? buildSocialMediaItem(
                      'assets/icons/instagram.png',
                      'Instagram',
                      company!.instagram!,
                      SocialMediaType.Instagram)
                  : const SizedBox(),
              company?.facebook != null
                  ? buildSocialMediaItem('assets/icons/facebook.png',
                      'Facebook', company!.facebook!, SocialMediaType.Facebook)
                  : const SizedBox(),
              company?.tiktok != null
                  ? buildSocialMediaItem('assets/icons/tiktok.png', 'TikTok',
                      company!.tiktok!, SocialMediaType.TikTok)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
