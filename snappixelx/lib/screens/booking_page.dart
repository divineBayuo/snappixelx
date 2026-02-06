import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/core/responsive_helper.dart';
import 'package:snappixelx/services/booking_service.dart';
import 'package:snappixelx/widgets/hover_scale.dart';
import 'package:snappixelx/widgets/navbar.dart';

class Bookingpage extends StatefulWidget {
  final String? prefilledPackage;

  const Bookingpage({super.key, this.prefilledPackage});

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
  final notesController = TextEditingController();

  String? selectedEvent;
  DateTime? selectedDate;
  bool isSubmitting = false;

  final List<String> eventTypes = [
    "Wedding",
    "Portrait",
    "Graduation",
    "Corporate",
    "Event Coverage",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    // pre-fill notes if package was selected
    if (widget.prefilledPackage != null) {
      notesController.text = 'Selected Package: ${widget.prefilledPackage}';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dateController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // date picker
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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

    try {
      // Create booking model
      final booking = BookingModel(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        eventType: selectedEvent!,
        date: selectedDate!,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        packageName: widget.prefilledPackage,
      );

      // Submit to backend
      final result = await BookingService.createBooking(booking);

      if (result['success']) {
        // Send confirmation email
        await BookingService.sendBookingConfirmation(booking);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ?? 'Booking submitted successfully',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // show success dialog
          _showSuccessDialog(booking);

          // reset form
          _formKey.currentState!.reset();
          setState(() {
            selectedEvent = null;
            selectedDate = null;
          });
          nameController.clear();
          phoneController.clear();
          emailController.clear();
          dateController.clear();
          notesController.clear();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to submit booking'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  void _showSuccessDialog(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 10),
            Text(
              'Booking Confirmed!',
              style: GoogleFonts.playfair(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your booking has been successfully submitted.',
              style: GoogleFonts.playfair(),
            ),
            const SizedBox(height: 15),
            _bookingDetail('Name', booking.name),
            _bookingDetail('Event', booking.eventType),
            _bookingDetail(
              'Date',
              '${booking.date.day}/${booking.date.month}/${booking.date.year}',
            ),
            if (booking.packageName != null)
              _bookingDetail('Package', booking.packageName!),
            const SizedBox(height: 10),
            Text(
              'We\'ll contact you shortly on ${booking.phone}',
              style: GoogleFonts.playfair(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.playfair(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.playfair(fontWeight: FontWeight.bold),
          ),
          Text(value, style: GoogleFonts.playfair()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      body: Stack(
        children: [
          background(),

          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: isMobile ? 80 : 100),
                  title(isMobile),
                  const SizedBox(height: 30),
                  bookingForm(isMobile),
                  SizedBox(height: isMobile ? 60 : 120),
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
  Widget title(bool isMobile) {
    return Text(
      "Book Appointment",
      style: GoogleFonts.playfair(
        fontSize: isMobile ? 28 : 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // form
  Widget bookingForm(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 0),
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400),
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
              validator: (v) =>
                  v == null || v.isEmpty ? "Name is required" : null,
            ),

            buildField(
              controller: phoneController,
              hint: "Phone Number",
              keyboard: TextInputType.phone,
              formatter: FilteringTextInputFormatter.digitsOnly,
              validator: (v) =>
                  v == null || v.length < 10 ? "Enter valid phone" : null,
            ),

            buildField(
              controller: emailController,
              hint: "Email Address",
              keyboard: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return "Email is required";
                if (!v.contains("@") || !v.contains(".")) {
                  return "Enter valid email";
                }
                return null;
              },
            ),

            // event type
            DropdownButtonFormField<String>(
              style: GoogleFonts.playfair(
                textStyle: TextStyle(color: Colors.black),
              ),
              value: selectedEvent,
              hint: Text(
                "Event Type",
                style: GoogleFonts.playfair(
                  color: Colors.grey[700],
                  textStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
              ),
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
              decoration: input("Preferred Date").copyWith(
                suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[700]),
              ),
              onTap: pickDate,
              validator: (v) => v == null || v.isEmpty ? "Select a date" : null,
            ),

            const SizedBox(height: 12),

            // notes field
            TextFormField(
              style: GoogleFonts.playfair(
                textStyle: TextStyle(color: Colors.black),
              ),
              controller: notesController,
              maxLines: 4,
              decoration: input("Additional Notes (Optional)").copyWith(
                hintText: "Any special requests or details...",
                alignLabelWithHint: true,
              ),
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
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  "Submit Booking",
                  style: GoogleFonts.playfair(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
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
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.5, color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
