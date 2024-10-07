import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrescriptionManagementPage extends StatefulWidget {
  const PrescriptionManagementPage({Key? key}) : super(key: key);

  @override
  _PrescriptionManagementPageState createState() => _PrescriptionManagementPageState();
}

class _PrescriptionManagementPageState extends State<PrescriptionManagementPage> {
  final _formKey = GlobalKey<FormState>();
  String _medicineName = '';
  String _amount = '';
  bool _morning = false;
  bool _afternoon = false;
  bool _night = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<Map<String, dynamic>> _prescriptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Prescriptions'),
        backgroundColor: const Color(0xFF2B9873),
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1_optimized.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.white), // Set text color to white
                    decoration: const InputDecoration(
                      labelText: 'Medicine Name',
                      labelStyle: TextStyle(color: Colors.white), // Set label color to white
                    ),
                    onSaved: (value) {
                      _medicineName = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a medicine name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white), // Set text color to white
                    decoration: const InputDecoration(
                      labelText: 'Amount (e.g., mg, ml)',
                      labelStyle: TextStyle(color: Colors.white), // Set label color to white
                    ),
                    onSaved: (value) {
                      _amount = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Morning', style: TextStyle(color: Colors.white)),
                    value: _morning,
                    onChanged: (value) {
                      setState(() {
                        _morning = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Afternoon', style: TextStyle(color: Colors.white)),
                    value: _afternoon,
                    onChanged: (value) {
                      setState(() {
                        _afternoon = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Night', style: TextStyle(color: Colors.white)),
                    value: _night,
                    onChanged: (value) {
                      setState(() {
                        _night = value ?? false;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != _startDate) {
                              setState(() {
                                _startDate = picked;
                              });
                            }
                          },
                          controller: TextEditingController(
                            text: DateFormat('yyyy-MM-dd').format(_startDate),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != _endDate) {
                              setState(() {
                                _endDate = picked;
                              });
                            }
                          },
                          controller: TextEditingController(
                            text: DateFormat('yyyy-MM-dd').format(_endDate),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _savePrescription();
                      }
                    },
                    child: const Text('Save Prescription'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = _prescriptions[index];
                  return Card(
                    child: ListTile(
                      title: Text(prescription['name']),
                      subtitle: Text(
                          'Amount: ${prescription['amount']}, Time: ${_getTimeOfDay(prescription)}, Duration: ${prescription['startDate']} to ${prescription['endDate']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _prescriptions.removeAt(index);
                              });
                            },
                          ),
                          prescription['ordered']
                              ? const Text(
                            'Ordered',
                            style: TextStyle(color: Colors.green),
                          )
                              : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                prescription['ordered'] = true;
                              });
                            },
                            child: const Text('Order'),
                          ),
                        ],
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

  void _savePrescription() {
    setState(() {
      _prescriptions.add({
        'name': _medicineName,
        'amount': _amount,
        'morning': _morning,
        'afternoon': _afternoon,
        'night': _night,
        'startDate': DateFormat('yyyy-MM-dd').format(_startDate),
        'endDate': DateFormat('yyyy-MM-dd').format(_endDate),
        'ordered': false, // Add order status
      });
    });
  }

  String _getTimeOfDay(Map<String, dynamic> prescription) {
    List<String> times = [];
    if (prescription['morning']) times.add('Morning');
    if (prescription['afternoon']) times.add('Afternoon');
    if (prescription['night']) times.add('Night');
    return times.join(', ');
  }
}
