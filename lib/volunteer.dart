import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerListPage extends StatefulWidget {
  @override
  _VolunteerListPageState createState() => _VolunteerListPageState();
}

class _VolunteerListPageState extends State<VolunteerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer List'),
      ),
      body: _buildVolunteerList(),
    );
  }

  Widget _buildVolunteerList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('volunteers')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['email']),
            );
          }).toList(),
        );
      },
    );
  }
}

// Example data for volunteers
List<Map<String, dynamic>> dummyVolunteers = [
  {
    'name': 'Aakash',
    'email': 'aakash@example.com',
  },
  {
    'name': 'Jayesh',
    'email': 'jayesh@example.com',
  },
  {
    'name': 'Mithun',
    'email': 'mithun@example.com',
  },
];
