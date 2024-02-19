import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registr_login/volunteer.dart';

class NgoPage extends StatefulWidget {
  const NgoPage({Key? key}) : super(key: key);

  @override
  _NgoPageState createState() => _NgoPageState();
}

class _NgoPageState extends State<NgoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _donationRequestsCollection =
      FirebaseFirestore.instance.collection('requestfood');

  CollectionReference<Map<String, dynamic>> _fulfilledRequestsCollection =
      FirebaseFirestore.instance.collection('fullfilledrequest');
  Widget _buildFoodRequestsPage() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Food Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _donationRequestsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return Card(
                      child: ListTile(
                        title: Text(document['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Address: ${document['address']}'),
                            Text('Quantity: ${document['quantity']}'),
                            Text('Contact: ${document['phone']}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          child: const Text('Fulfill'),
                          onPressed: () => fulfillRequest(document.id),
                        ),
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodDonationsPage() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Food Donations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('donations').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error occurred');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final donations = snapshot.data?.docs;

              return ListView.builder(
                itemCount: donations?.length ?? 0,
                itemBuilder: (context, index) {
                  final donation =
                      donations?[index].data() as Map<String, dynamic>;
                  //final name = donation['name'];
                  final qty = donation['quantity'];
                  final address = donation['address'];
                  final description = donation['description'];

                  return ListTile(
                    title: Text(description),
                    subtitle: Text(address),
                    trailing: Text(qty),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFulfilledRequestsPage() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Fulfilled Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _fulfilledRequestsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return Card(
                      child: ListTile(
                        title: Text(document['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Address: ${document['address']}'),
                            Text('Quantity: ${document['quantity']}'),
                            Text('Contact: ${document['phone']}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  int _currentIndex = 0;

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildFoodRequestsPage();
      case 1:
        return _buildFoodDonationsPage();
      case 2:
        return _buildFulfilledRequestsPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Page'),
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Food Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.donut_large),
            label: 'Food Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.man),
            label: 'Volunteers',
          
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Fulfilled Requests',
          ),
        ],
      ),
    );
  }

  Future<void> fulfillRequest(String documentId) async {
    final DocumentSnapshot<Map<String, dynamic>> document =
        await _donationRequestsCollection.doc(documentId).get();

    if (document.exists) {
      final requestData = document.data();

      if (requestData != null) {
        await _fulfilledRequestsCollection.doc(documentId).set(requestData);
        await _donationRequestsCollection.doc(documentId).delete();
      }
    }
  }
}
