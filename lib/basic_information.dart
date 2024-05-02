import 'package:flutter/material.dart';

class BasicInformation extends StatefulWidget {
  final String name;
  final String email;
  final String contactNumber;

  const BasicInformation({
    Key? key,
    required this.name,
    required this.email,
    required this.contactNumber,
  }) : super(key: key);

  @override
  _BasicInformationState createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation> {
  bool _basicInfoExpanded = false;
  bool _projectInfoExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInfoCard(
            title: 'Basic Information',
            expanded: _basicInfoExpanded,
            onTap: () {
              setState(() {
                _basicInfoExpanded = !_basicInfoExpanded;
              });
            },
            children: [
              _buildInfoRow(Icons.person, 'Name', widget.name),
              _buildDivider(),
              _buildInfoRow(Icons.email, 'Email', widget.email),
              _buildDivider(),
              _buildInfoRow(Icons.phone, 'Contact Number', widget.contactNumber),
            ],
          ),
          _buildInfoCard(
            title: 'Project Information',
            expanded: _projectInfoExpanded,
            onTap: () {
              setState(() {
                _projectInfoExpanded = !_projectInfoExpanded;
              });
            },
            children: [
              _buildInfoRow(Icons.assignment, 'Project Name', ''),
              _buildDivider(),
              _buildInfoRow(Icons.attach_money, 'Expenditure Cost', ''),
              _buildDivider(),
              _buildInfoRow(Icons.monetization_on, 'Estimated Cost', ''),
              _buildDivider(),
              _buildInfoRow(Icons.calendar_today, 'Start Date', ''),
              _buildDivider(),
              _buildInfoRow(Icons.calendar_today, 'End Date', ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required bool expanded,
    required Function() onTap,
    required List<Widget> children,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 5,
        color: expanded ? Colors.purple : Colors.pink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (expanded) ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white,
      ),
    );
  }
}
