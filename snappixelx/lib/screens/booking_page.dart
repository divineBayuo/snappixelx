import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/widgets/hover_scale.dart';
import 'package:snappixelx/widgets/navbar.dart';

class Bookingpage extends StatefulWidget {
  const Bookingpage({super.key});

  @override
  State<Bookingpage> createState() => _BookingpageState();
}

class _BookingpageState extends State<Bookingpage> {
  int selectedIndex = 3;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();

  String? selectedEvent;
  DateTime? selectedDate;
  bool isSubmitting = false;

  final List<String> eventTypes = [
    "Wedding",
    "Portrait",
    "Graduation",
    "Corporate",
    "Event Coverage",
  ];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dateController.dispose();
    super.dispose();
  }

  // date picker
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // submit
  void submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    // backend simulation
    await Future.delayed(const Duration(seconds: 1));

    final bookingDate = {
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "eventType": selectedEvent,
      "date": selectedDate,
    };

    debugPrint("Booking Date: $bookingDate");

    setState(() => isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking submitted successfully")),
    );

    _formKey.currentState!.reset();
    dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          background(),

          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),

                  title(),

                  const SizedBox(height: 30),

                  bookingForm(),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              selectedIndex: selectedIndex,
              onTabSelected: (index) {
                setState(() => selectedIndex = index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // background
  Widget background() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bookback.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(color: Colors.black.withOpacity(0.55)),
    );
  }

  // title
  Widget title() {
    return Text(
      "Book Appointment",
      style: GoogleFonts.playfair(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // form
  Widget bookingForm() {
    return Container(
      padding: const EdgeInsets.all(28),
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 15, color: Colors.black.withOpacity(0.25)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildField(
              controller: nameController,
              hint: "Full Name",
              validator: (v) => v!.isEmpty ? "Name is required" : null,
            ),

            buildField(
              controller: phoneController,
              hint: "Phone Number",
              keyboard: TextInputType.phone,
              formatter: FilteringTextInputFormatter.digitsOnly,
              validator: (v) => v!.length < 10 ? "Enter valid phone" : null,
            ),

            buildField(
              controller: emailController,
              hint: "Email Address",
              keyboard: TextInputType.emailAddress,
              validator: (v) => !v!.contains("@") ? "Enter valid email" : null,
            ),

            const SizedBox(height: 12),

            // event type
            DropdownButtonFormField<String>(
              style: GoogleFonts.playfair(
                textStyle: TextStyle(color: Colors.black),
              ),
              value: selectedEvent,
              hint: Text("Event Type"),
              decoration: input("Event Type"),
              dropdownColor: Colors.white,
              items: eventTypes
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: GoogleFonts.playfair(
                          textStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => selectedEvent = value),
              validator: (v) => v == null ? "Select event type" : null,
            ),

            const SizedBox(height: 12),

            // date picker
            TextFormField(
              style: GoogleFonts.playfair(
                textStyle: TextStyle(color: Colors.black),
              ),
              controller: dateController,
              readOnly: true,
              decoration: input("Preferred Date"),
              onTap: pickDate,
              validator: (v) => v!.isEmpty ? "Select a date" : null,
            ),

            const SizedBox(height: 25),

            submitButton(),
          ],
        ),
      ),
    );
  }

  // field builder
  Widget buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    TextInputFormatter? formatter,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: GoogleFonts.playfair(textStyle: TextStyle(color: Colors.black)),
        controller: controller,
        keyboardType: keyboard,
        inputFormatters: formatter != null ? [formatter] : null,
        validator: validator,
        decoration: input(hint),
      ),
    );
  }

  // submit bn
  Widget submitButton() {
    return HoverScale(
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: isSubmitting ? null : submitForm,
          child: isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  "Submit Booking",
                  style: GoogleFonts.playfair(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
        ),
      ),
    );
  }

  InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.playfair(
        textStyle: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey[700],
        ),
      ),
      filled: true,
      fillColor: Colors.grey[100],
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
