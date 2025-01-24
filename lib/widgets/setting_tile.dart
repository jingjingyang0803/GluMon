import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget>? children;

  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color:
                            Colors.black), // Use `primaryTextColor` if defined
                  ),
                  if (subtitle != null) // Show subtitle only if provided
                    Text(
                      subtitle!,
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
              if (icon != null) Icon(icon, color: Colors.black),
            ],
          ),
          if (children != null) ...[
            SizedBox(height: 12),
            Column(children: children!),
          ],
        ],
      ),
    );
  }
}
