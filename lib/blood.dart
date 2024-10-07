import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BloodDonationPage extends StatefulWidget {
  @override
  _BloodDonationPageState createState() => _BloodDonationPageState();
}

class _BloodDonationPageState extends State<BloodDonationPage> {
  CollectionReference bloodRequests = FirebaseFirestore.instance.collection('blood_requests');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? loggedInUser;
  String username = '';
  int unitsDonated = 0;
  int livesSaved = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getDonationStats();
  }

  // Retrieve current logged-in user
  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
      // Fetch the user's details from Firestore (if stored)
      DocumentSnapshot userDoc = await users.doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'] ?? 'User';
        });
      }
    }
  }

  // Retrieve blood donation stats for the user
  void _getDonationStats() async {
    if (loggedInUser != null) {
      DocumentSnapshot userDoc = await users.doc(loggedInUser!.uid).get();
      if (userDoc.exists) {
        setState(() {
          unitsDonated = userDoc['units_donated'] ?? 0;
          livesSaved = userDoc['lives_saved'] ?? 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donate', style: TextStyle(letterSpacing: 1.5)),
        backgroundColor: Color(0xFF2B9873),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1_optimized.png'), // Path to your background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with greeting and stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hi $username,',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Column(
                      children: [
                        _buildStatCard('Units Donated', unitsDonated),
                        SizedBox(height: 8),
                        _buildStatCard('Lives Saved', livesSaved),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Urgent Blood Requests',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: bloodRequests.orderBy('date', descending: true).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No blood requests found.'));
                      }

                      var requests = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          var request = requests[index];
                          return BloodRequestCard(
                            bloodGroup: request['blood_group'],
                            unitsNeeded: request['units'],
                            mobileNumber: request['mobile_number'],
                            date: request['date'].toDate(),
                            onDonatePressed: () {
                              _sendDonationNotification(request);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for stats card
  Widget _buildStatCard(String title, int value) {
    return Container(
      width: 120,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$value',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendDonationNotification(DocumentSnapshot request) async {
    // Simulate sending a notification by displaying an alert dialog
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Donation Request Sent!'),
          content: Text('Details sent to ${request['mobile_number']}.'), // Display the contact number
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    // Increment user's donation stats (units donated and lives saved)
    if (loggedInUser != null) {
      await users.doc(loggedInUser!.uid).update({
        'units_donated': FieldValue.increment(1),
        'lives_saved': FieldValue.increment(1), // Assuming 1 life saved per donation
      });
    }
  }
}

class BloodRequestCard extends StatelessWidget {
  final String bloodGroup;
  final String unitsNeeded;
  final String mobileNumber;
  final DateTime date;
  final VoidCallback onDonatePressed;

  BloodRequestCard({
    required this.bloodGroup,
    required this.unitsNeeded,
    required this.mobileNumber,
    required this.date,
    required this.onDonatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(bloodGroup, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Blood Group: $bloodGroup', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Units Needed: $unitsNeeded', style: TextStyle(fontSize: 16)),
                  Text('Mobile Number: $mobileNumber', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('Date: ${date.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onDonatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[200], // Button background color
              ),
              child: Text('DONATE'),
            ),
          ],
        ),
      ),
    );
  }
}
