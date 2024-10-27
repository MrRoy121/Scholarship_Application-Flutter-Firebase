import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> instructions = [
    {
      'title': 'Motivation Letter',
      'icon': Icons.edit,
      'description': 'Craft a compelling motivation letter.',
    },
    {
      'title': 'Recommendation Letters',
      'icon': Icons.person_add,
      'description': 'Get endorsements from mentors or professors.',
    },
    {
      'title': 'CV',
      'icon': Icons.assignment,
      'description': 'Prepare a professional curriculum vitae.',
    },
    {
      'title': 'Apply for University',
      'icon': Icons.school,
      'description': 'Submit your application to your chosen university.',
    },
    {
      'title': 'Apply for Scholarships',
      'icon': Icons.monetization_on,
      'description': 'Explore and apply for available scholarships.',
    },
    {
      'title': 'Appointments Booking',
      'icon': Icons.calendar_today,
      'description': 'Schedule appointments with advisors or institutions.',
    },
    {
      'title': 'Interview Tips',
      'icon': Icons.chat,
      'description': 'Prepare effectively for interviews.',
    },
    {
      'title': 'IELTS Booking',
      'icon': Icons.language,
      'description': 'Book your IELTS exam conveniently.',
    },
    {
      'title': 'IELTS Online Courses',
      'icon': Icons.online_prediction,
      'description': 'Enroll in online courses to improve IELTS skills.',
    },
    {
      'title': 'Personal Statement',
      'icon': Icons.note,
      'description': 'Write a persuasive personal statement.',
    },
    {
      'title': 'Letter of Intent',
      'icon': Icons.file_copy,
      'description': 'Draft a formal letter of intent.',
    },
  ];
  final String whatsappLink1 = 'https://wa.me/qr/QRLG2SPYRALKO1';
  final String whatsappLink2 = 'https://wa.me/qr/AGIBZCC4MX6SA1';

  void _launchWhatsApp(String baseUrl, String message) async {
    launchUrl(Uri.parse(baseUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).cardColor,
        title: Text(
          'Our Services',
          style: TextStyle(
            color: Theme.of(context).cardColor,
            fontSize: 18,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              launchUrl(Uri.parse(whatsappLink1));
            },
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: () async {
              launchUrl(Uri.parse(whatsappLink2));
            },
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          SizedBox(width: 10,),
        ],
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: instructions.length,
                itemBuilder: (context, index) {
                  final instruction = instructions[index];

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      onTap: () => _showBottomSheet(context, instruction['title']),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[700],
                        child: Icon(
                          instruction['icon'],
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        instruction['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        instruction['description'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String selectedInstruction) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Send "$selectedInstruction" via WhatsApp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _launchWhatsApp(whatsappLink1, selectedInstruction),
                    icon: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Theme.of(context).cardColor,
                    ),
                    label: Text(
                      'WhatsApp 1',
                      style: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _launchWhatsApp(whatsappLink2, selectedInstruction),
                    icon: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Theme.of(context).cardColor,
                    ),
                    label: Text(
                      'WhatsApp 2',
                      style: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
