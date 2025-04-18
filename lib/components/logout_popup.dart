import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';

import 'custom_button.dart';
import 'custom_divider.dart';

class LogoutPopup extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const LogoutPopup(
      {required this.onConfirm, required this.onCancel, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: 12), // Reduced vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomDivider(),
          SizedBox(height: 8),
          Text(
            'Logout?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Are you sure you wanna logout?',
            style: TextStyle(
              fontSize: 18,
              color: primaryOrange,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomButton(
                      text: "No",
                      backgroundColor: lightGreen,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      } // Close the popup},
                      ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomButton(
                    text: "Yes",
                    backgroundColor: primaryGreen,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
