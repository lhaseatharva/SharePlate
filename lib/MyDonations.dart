import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDonations extends StatefulWidget {
  const MyDonations({Key? key}) : super(key: key);

  @override
  _MyDonationsState createState() => _MyDonationsState();
}

class _MyDonationsState extends State<MyDonations> {
  late String userId;
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("My Donations"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('donations')
              .where('userId', isEqualTo: userId)
              .snapshots(),
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
    );
  }
}
