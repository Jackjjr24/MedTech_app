import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const BloodRequestApp());
}

class BloodRequestApp extends StatelessWidget {
  const BloodRequestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RequestBloodPage(),
    );
  }
}

class RequestBloodPage extends StatefulWidget {
  const RequestBloodPage({Key? key}) : super(key: key);

  @override
  _RequestBloodPageState createState() => _RequestBloodPageState();
}

class _RequestBloodPageState extends State<RequestBloodPage> {
  bool _isRequestSubmitted = false;

  // Text controllers to capture input
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();

  @override
  void dispose() {
    _bloodGroupController.dispose();
    _mobileNumberController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  // Submit request to Firestore
  Future<void> _submitBloodRequest() async {
    String bloodGroup = _bloodGroupController.text;
    String mobileNumber = _mobileNumberController.text;
    String units = _unitsController.text;

    if (bloodGroup.isNotEmpty && mobileNumber.isNotEmpty && units.isNotEmpty) {
      try {
        CollectionReference requests =
        FirebaseFirestore.instance.collection('blood_requests');

        await requests.add({
          'blood_group': bloodGroup,
          'mobile_number': mobileNumber,
          'units': units,
          'status': 'pending', // Add status field for new requests
          'date': DateTime.now(),
        });

        setState(() {
          _isRequestSubmitted = true;
        });
      } catch (e) {
        print('Error adding request: $e');
        // Show error message on UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
    }
  }

  // Fetch recent requests from Firestore
  Stream<QuerySnapshot> _getRecentRequests() {
    return FirebaseFirestore.instance
        .collection('blood_requests')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Get status icon based on the status
  Icon _getStatusIcon(String status) {
    if (status == 'got') {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (status == 'not_got') {
      return const Icon(Icons.cancel, color: Colors.red);
    } else {
      return const Icon(Icons.hourglass_empty, color: Colors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous page
          },
        ),
        backgroundColor: Color(0xFF2B9873),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1_optimized.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Center(
                    child: Text(
                      'BLOOD REQUEST',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Do you need blood? 🩸',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _bloodGroupController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter the blood group',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _mobileNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter mobile number',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _unitsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Required units of blood',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          _isRequestSubmitted = false;
                        });
                        await _submitBloodRequest();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('SUBMIT BLOOD REQUEST'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isRequestSubmitted)
                    const Center(
                      child: Text(
                        'Request Submitted successfully!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    'My Recent Request 🩸',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: _getRecentRequests(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var requests = snapshot.data!.docs;
                      if (requests.isEmpty) {
                        return const Text(
                          'No recent requests',
                          style: TextStyle(color: Colors.white),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          var request = requests[index].data() as Map<String, dynamic>;

                          // Check if 'status' exists, otherwise set to 'pending'
                          String status = request.containsKey('status')
                              ? request['status']
                              : 'pending';

                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(request['blood_group']),
                            ),
                            title: Text(
                              'Requested for ${request['blood_group']} blood',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              '${request['date'].toDate()}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: _getStatusIcon(status), // Use the status to get the icon
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
