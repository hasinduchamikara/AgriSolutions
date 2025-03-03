import 'package:agrifront/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/booking.model.dart';

class BookingEditPage extends StatefulWidget {
  BookingEditPage({Key? key, required this.booking}) : super(key: key);

  final BookingModel booking;
  final BookingService issueService = BookingService();

  @override
  _BookingEditPageState createState() => _BookingEditPageState();
}

class _BookingEditPageState extends State<BookingEditPage> {
  final _formKey = GlobalKey<FormState>();

  late BookingModel booking;
  List<BookingModel> issues = [];

  @override
  void initState() {
    super.initState();
    // _getEmployees();
    setState(() {
      booking = widget.booking;
    });
  }

  // void _getEmployees() {
  //   widget.issueService.getAll().then((value) => {
  //         setState(() {
  //           issues = value;
  //         })
  //       });
  // }

  void _save() {
    widget.issueService
        .updateBooking(booking)
        .then((value) => {
              Fluttertoast.showToast(
                  msg: 'Update Successfully',
                  toastLength: Toast.LENGTH_LONG,
                  fontSize: 20,
                  backgroundColor: Colors.green),
              Navigator.pop(context, 'Saved')
            })
        .catchError((err) => {print(err)});
  }

  void _cancel() {
    Fluttertoast.showToast(
        msg: 'Cancelled',
        toastLength: Toast.LENGTH_LONG,
        fontSize: 20,
        backgroundColor: Colors.green);
    Navigator.pop(context, 'Cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NevigationDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 5, 156, 10),
          title: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Update Bookings",
              style: TextStyle(
                  fontSize: 24.0, color: Color.fromARGB(215, 255, 255, 255)),
            ),
          ),
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 247, 213, 255)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(16, 101, 235, 44),
        ),
        height: 900,
        child: Stack(
          children: [
            Positioned(
                top: 500,
                left: 0,
                child: Container(
                  width: 310,
                  height: 210,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/vehicle.png'),
                        fit: BoxFit.fill),
                  ),
                )),
            SingleChildScrollView(
              padding: const EdgeInsets.all(35),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        maxLength: 250,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.title),
                          border: OutlineInputBorder(),
                          labelText: 'Type the Contact No',
                        ),
                        initialValue: booking.contactno,
                        onChanged: (text) {
                          booking.contactno = text;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Contact No is required!';
                          }
                          return null;
                        }),
                    const SizedBox(height: 15),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        maxLength: 600,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.image),
                          border: OutlineInputBorder(),
                          labelText: 'Enter the Hours',
                        ),
                        initialValue: booking.hours,
                        onChanged: (text) {
                          booking.hours = text;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Hours is required!';
                          }
                          return null;
                        }),
                    const SizedBox(height: 15),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        maxLength: 35,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.male),
                          border: OutlineInputBorder(),
                          labelText: 'Enter Address',
                        ),
                        initialValue: booking.address,
                        onChanged: (text) {
                          booking.address = text;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Address is required!';
                          }
                          return null;
                        }),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.save,
                            color: Colors.black54,
                          ),
                          label: const Text('Update'),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _save();
                            }
                          },
                        ),
                        const SizedBox(width: 50),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.cancel, color: Colors.black54),
                          label: const Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            _cancel();
                          },
                        ),
                      ],
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
