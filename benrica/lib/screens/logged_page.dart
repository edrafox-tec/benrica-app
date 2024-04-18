import 'package:benrica/screens/home_page.dart';
import 'package:benrica/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoggedPage extends StatefulWidget {
  @override
  _LoggedPageState createState() => _LoggedPageState();
}

class _LoggedPageState extends State<LoggedPage> {
  int actualPage = 0;
  late PageController pc;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: actualPage);
  }

  setActualPage(page) {
    setState(() {
      actualPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (actualPage == 1 || actualPage == 2) {
          pc.animateToPage(0,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        } else if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pressione novamente para sair'),
            ),
          );
        } else {
          context.pushReplacement('/login');
          // context.read<AuthService>().logout();
        }
      },
      child: Scaffold(
        body: PageView(
          controller: pc,
          onPageChanged: setActualPage,
          children: [
            HomePage(),
            // HistoryPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: actualPage,
          onTap: (page) {
            pc.animateToPage(page,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.handyman_outlined), label: 'Serviços'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.newspaper_outlined), label: 'Histórico'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Configurações'),
          ],
        ),
      ),
    );
  }
}
