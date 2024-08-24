import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionScreen extends StatelessWidget {
  final List<String> instructions = [
    'Motivation Letter',
    'Recommendation Letters',
    'CV',
    'Apply for University',
    'Apply for Scholarships',
    'Appointments Booking',
    'Interview Tips',
    'IELTS Booking',
    'IELTS Online Courses',
    'Personal Statement',
    'Letter of Intent',
  ];

  final String whatsappLink1 = 'https://wa.me/qr/AGIBZCC4MX6SA1?text=';
  final String whatsappLink2 = 'https://wa.me/qr/QRLG2SPYRALKO1?text=';

  void _launchWhatsApp(String baseUrl, String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final url = "$baseUrl$encodedMessage";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
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
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      onTap: () {
                        final selectedInstruction = instructions[index];
                        _showBottomSheet(context, selectedInstruction);
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[700],
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        instructions[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
                    onPressed: () =>
                        _launchWhatsApp(whatsappLink1, selectedInstruction),
                    icon: FaIcon(FontAwesomeIcons.whatsapp),
                    label: Text('WhatsApp 1'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _launchWhatsApp(whatsappLink2, selectedInstruction),
                    icon: FaIcon(FontAwesomeIcons.whatsapp),
                    label: Text('WhatsApp 2'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
