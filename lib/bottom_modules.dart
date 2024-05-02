import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'usercommunity.dart'; // Import the CommunityPage widget

class BottomModules extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onModuleSelected;
  final VoidCallback onCommunityPressed; // Callback for the community button

  const BottomModules({
    Key? key,
    required this.selectedIndex,
    required this.onModuleSelected,
    required this.onCommunityPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = Colors.black;
    final unselectedColor = Colors.black87;
    final selectedTextColor = Colors.white;

    Widget _buildModule(String name, IconData icon, int index, double textSize) {
      final isSelected = selectedIndex == index;
      final backgroundColor = isSelected ? selectedColor : Colors.transparent;
      final textColor = isSelected ? Colors.white : unselectedColor;

      return GestureDetector(
        onTap: () {
          if (index == 1) {
            onCommunityPressed(); // Call the community button callback
          } else {
            onModuleSelected(index);
          }
          HapticFeedback.selectionClick(); // Add haptic feedback on tap
        },
        child: Container(
          height: 60, // Adjust height as needed
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: 24, // Adjust icon size as needed
                ),
                SizedBox(width: 8), // Add spacing between icon and text
                Text(
                  name.trim(), // Trimming to remove leading/trailing spaces
                  style: TextStyle(
                    fontSize: textSize,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Colors.greenAccent[50],
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            _buildModule(' Home ', Icons.home, 0, 12),
            SizedBox(width: 16),
            _buildModule('Community', Icons.people, 1, 14),
            SizedBox(width: 16),
            _buildModule('Estimate Cost', Icons.monetization_on, 2, 16),
            SizedBox(width: 16),
            _buildModule('Budget Manage', Icons.account_balance_wallet, 3, 14),
            SizedBox(width: 16),
            _buildModule('Vendor ', Icons.recommend, 4, 14),
          ],
        ),
      ),
    );
  }
}
