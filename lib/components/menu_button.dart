import 'package:flutter/material.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/enums/menu_action.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/views/main_view.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.title});

  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  PreferredSizeWidget? bar(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: const [
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.5),
                          child: Icon(Icons.logout),
                        ),
                      ),
                      TextSpan(
                        text: ' Logout',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
        )
      ],
    );
  }
}