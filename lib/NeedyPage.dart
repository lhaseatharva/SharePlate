import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NeedyRequestPage extends StatefulWidget {
  NeedyRequestPage();

  @override
  State<NeedyRequestPage> createState() => _NeedyRequestPageState();
}

class _NeedyRequestPageState extends State<NeedyRequestPage> {
  late String userId;
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Request Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Assign form key to the Form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 210,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
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
              Center(
                child: Text(
                  'Together We Can End Hunger',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        // Validate phone number using regular expression
                        final phoneRegex = r'^\d{10}$';
                        if (!RegExp(phoneRegex).hasMatch(value)) {
                          return 'Please enter a valid 10-digit phone number';
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
                          return 'Please enter the number of persons';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Number of persons',
                        hintText: 'Enter number of persons',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a food type';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Food Type',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text("Select Food Type"),
                      value: _selectedOption,
                      items: <String>['Veg', 'Non-Veg'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Validation successful, submit the request
                          requestFood(context, {
                            'name': _nameController.text,
                            'phone': _phoneController.text,
                            'address': _addressController.text,
                            'quantity': _quantityController.text,
                            'food-type': _selectedOption
                          }, userId);
                        }
                      },
                      child: const Text(
                        'Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void requestFood(
  BuildContext context,
  Map<String, dynamic> requestData,
  String userId,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  requestData['userId'] = userId;
  // Create a new document in the "requestfood" collection
  firestore.collection("requestfood").add(requestData).then((_) {
    // Show a success dialog
    var alertDialog = const AlertDialog(
      title: Text("Your request submitted successfully"),
      content: Text("Please be patient while we arrange food for you"),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }).catchError((error) {
    // Show an error dialog
    var errorDialog = const AlertDialog(
      title: Text("Error"),
      content: Text("An error occurred while submitting your request"),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog;
      },
    );
  });
}