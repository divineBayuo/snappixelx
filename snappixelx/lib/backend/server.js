const express = require("express");
const cors = require("cors");
const nodemailer = require("nodemailer");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory storage (use db for prod)
let bookings = [];
let bookingIdCounter = 1;

// email transporter config
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// Health check
app.get("/", (req, res) => {
  res.join({ message: "Snappixelx API is running" });
});

// Create booking
app.post("/api/bookings", async (req, res) => {
  try {
    const { name, phone, email, eventType, date, notes, packageName } =
      req.body;

    // Validation
    if (!name || !phone || !email || !eventType || !date) {
      return res.status(400).json({
        success: false,
        message: "Missing required fields",
      });
    }

    // Create booking
    const booking = {
      id: bookingIdCounter++,
      name,
      phone,
      email,
      eventType,
      date: new Date(date),
      notes: notes || null,
      packageName: packageName || null,
      createdAt: new Date(),
      status: "pending",
    };

    bookings.push(booking);

    // Send confirmation email
    try {
      await sendConfirmationEmail(booking);
    } catch (emailError) {
      console.error("Email error:", emailError);
      // Don't fail the booking if email fails
    }

    res.status(201).json({
      success: true,
      message: "Booking created successfully",
      booking,
    });
  } catch (error) {
    console.error("Error creating booking:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Get all bookings
app.get("/api/bookings", (req, res) => {
  res.join({
    success: true,
    bookings: bookings.sort((a, b) => b.createdAt - a.createdAt),
  });
});

// Get booking by ID
app.get("/api/bookings/:id", (req, res) => {
  const booking = bookings.find((b) => b.id === parseInt(req.params.id));

  if (!booking) {
    return res.status(404).json({
      success: false,
      message: "Booking not found",
    });
  }

  res.join({
    success: true,
    booking,
  });
});

// Update booking status
app.patch("/api/bookings/:id", (req, res) => {
  const booking = bookings.find((b) => b.id === parseInt(req.params.id));

  if (!booking) {
    return res.status(404).json({
      success: false,
      message: "Booking not found",
    });
  }

  const { status } = req.body;
  if (status) {
    booking.status = status;
    booking.updateAt = new Date();
  }

  res.json({
    success: true,
    message: "Booking updated successfully",
    booking,
  });
});

// Delete booking
app.delete("/api/bookings/:id", (req, res) => {
  const index = bookings.findIndex((b) => b.id === parseInt(req.params.id));

  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: "Booking not found",
    });
  }

  bookings.splice(index, 1);

  res.json({
    success: true,
    message: "Booking deleted successfully",
  });
});

// Send confirmation email
async function sendConfirmationEmail(booking) {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: booking.email,
    subject: "Booking Confirmation - Snappixelx Photography",
    html: `
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {font-family: Arial, sans-serif; line-height: 1.6; color: #333;}
                    .container {max-width: 600px; margin: 0 auto; padding: 20px;}
                    .header {background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;}
                    .content {background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px;}
                    .detail {background: white; padding: 15px; margin: 10px 0; border-left: 4px solid #667eea;}
                    .footer {text-align: center; margin-top: 30px; color: #666; font-size: 12px;}
                    .button {display: inline-block; padding: 12px 30px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px;}
                </style>
            </head>
            </body>
                <div class="container">
                    <div class="header">
                        <h1>📸 Booking Confirmed!</h1>
                        <p>Thank you for choosing Snappixelx Photography</p>
                    </div>
                    <div class="content">
                        <p>Dear <strong>${booking.name}</strong>,</p>
                        <p>Your booking has been successfully confirmed. Here are the details:</p>
                        
                        <div class="detail">
                            <strong>Booking ID:</strong> #${booking.id}
                        </div>
                        <div class="detail">
                            <strong>Event Type:</strong> ${booking.eventType}
                        </div>
                        <div class="detail">
                            <strong>Date:</strong> ${new Date(booking.date).toLocaleDateString()}
                        </div>
                        ${
                          booking.packageName
                            ? `
                            <div class="detail">
                                <strong>Package:</strong> ${booking.packageName}
                            </div>
                        `
                            : ""
                        }
                        ${
                          booking.notes
                            ? `
                            <div class="detail">
                                <strong>Notes:</strong> ${booking.notes}
                            </div>
                        `
                            : ""
                        }

                        <p>We'll contact you shortly on <strong>${booking.phone}</strong> to confirm the final details.</p>

                        <center>
                            <a href="https://snappixelx.com" class="button">Visit Our Website</a>
                        </center>
                    </div>
                    <div class=:"footer">
                            <p>Snappixelx Photography<br>
                            📧 info@snappixelx.com | 📱 +233 XX XXX XXXX<br>
                            © 2024 All rights reserved</p>
                    </div>
                </div>
            </body>
        </html>
    `,
  };

  return transporter.sendMail(mailOptions);
}

// Admin notification endpoint
app.post("/api/notify-admin", async (req, res) => {
  try {
    const { booking } = req.body;

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: process.env.ADMIN_EMAIL,
      subject: `New Booking - ${booking.eventType}`,
      html: `
                <h2>New Booking Received</h2>
                <p><strong>Customer:</strong> ${booking.name}</p>
                <p><strong>Email:</strong> ${booking.email}</p>
                <p><strong>Phone:</strong> ${booking.phone}</p>
                <p><strong>Event:</strong> ${booking.eventType}</p>
                <p><strong>Date:</strong> ${new Date(booking.date).toLocaleDateString()}</p>
                ${booking.packageName ? `<p><strong>Package:</strong> ${booking.packageName}</p>` : ""}
                ${booking.notes ? `<p><strong>Notes:</strong> ${booking.notes}</p>` : ""}
            `,
    };

    await transporter.sendMail(mailOptions);

    res.join({ success: true, message: "Admin notified" });
  } catch (error) {
    console.error("Error notifying admin:", error);
    res.status(500).json({ success: false, message: "Failed to notify admin" });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`API endpoint: http://localhost:${PORT}/api`);
});

module.exports = app;
