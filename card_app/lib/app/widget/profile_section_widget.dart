import 'package:card_app/app/data/models/business_card.dart';
import 'package:card_app/app/theme/app_theme.dart';
import 'package:card_app/app/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';

class ProfileSectionWidget extends StatelessWidget {
  final BusinessCard card;
  final HomeViewModel viewModel;

  const ProfileSectionWidget({
    required this.card,
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              card.name.isNotEmpty ? card.name : "Unknown",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDarkColor,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              card.jobTitle.isNotEmpty ? card.jobTitle : "Unknown",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              card.companyName.isNotEmpty ? card.companyName : "Unknown",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
