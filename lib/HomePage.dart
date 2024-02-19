import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void donateFood(BuildContext context) {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String quantity = _quantityController.text;
    String description = _descriptionController.text;

    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a new document in the "donations" collection
    firestore.collection("donations").add({
      "name": name,
      "phone": phone,
      "address": address,
      "quantity": quantity,
      "description": description,
      "userId": userId
    }).then((_) {
      // Show a success dialog
      var alertDialog = const AlertDialog(
        title: Text("Donation request submitted successfully"),
        content: Text("Thank you for joining hands with us"),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        },
      );
    }).catchError((error) {
      // Show an error dialog
      var alertDialog = const AlertDialog(
        title: Text("Error"),
        content: Text("Failed to submit donation request"),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Request Food'),
              onTap: () {
                Navigator.pop(context);
                // Handle navigation to request food page
              },
            ),
            ListTile(
              title: const Text('My Donations'),
              onTap: () {
                Navigator.pop(context);
                // Handle navigation to my donations page
              },
            ),
            ListTile(
              title: const Text('NGO'),
              onTap: () {
                Navigator.pop(context);
                // Handle navigation to NGO page
              },
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text("Log Out")
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('SharePlate'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 210.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
                items: [
                  "assets/images/c1.jpg",
                  "assets/images/c2.jpg",
                  "assets/images/c3.jpg",
                  "assets/images/c4.jpg",
                  "assets/images/c5.jpg",
                  "assets/images/c6.jpg"
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset(i),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Donate Food & Spread the Smile',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _addressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _quantityController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the quantity of food';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'Enter the quantity of food',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description of the food';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter a description of the food',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          donateFood(context);
                        }
                      },
                      child: const Text(
                        'Donate',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
