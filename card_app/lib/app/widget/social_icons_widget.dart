import 'package:card_app/app/data/models/business_card.dart';
import 'package:card_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIconsWidget extends StatelessWidget {
  final BusinessCard card;

  const SocialIconsWidget({required this.card, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = [
      {'icon': FontAwesomeIcons.phone, 'url': 'tel:${card.phone}'},
      {'icon': FontAwesomeIcons.solidMessage, 'url': 'sms:${card.phone}'},
      {'icon': FontAwesomeIcons.solidEnvelope, 'url': 'mailto:${card.email}'},
      {'icon': FontAwesomeIcons.globe, 'url': card.website},
      {'icon': FontAwesomeIcons.linkedin, 'url': card.linkedin},
      {'icon': FontAwesomeIcons.facebook, 'url': card.facebook},
      {'icon': FontAwesomeIcons.instagram, 'url': card.instagram},
      {'icon': FontAwesomeIcons.youtube, 'url': card.youtube},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icons.sublist(0, 4).map((e) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    _buildIconButton(e['icon'] as IconData, e['url'] as String),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icons.sublist(4).map((e) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    _buildIconButton(e['icon'] as IconData, e['url'] as String),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          Get.dialog(AlertDialog(
            title: Text("Lỗi"),
            content: Text("Thiết bị không hỗ trợ chức năng này"),
          ));
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryColor,
        ),
        child: Icon(icon, color: AppTheme.iconActiveColor, size: 30),
      ),
    );
  }
}
