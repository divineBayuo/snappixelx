# Snappixelx Photography Booking App

A professional Flutter web and mobile application for a photography business with booking functionality, responsive design, and backend integration.

## ✨ Features

### 📱 **Fully Responsive Design**
- Adapts seamlessly to mobile, tablet, and desktop screens
- Mobile-first approach with hamburger menu on small screens
- Optimized layouts for all device sizes

### 🎨 **Pages**
1. **Homepage** - Hero section, services showcase, about section, social media links
2. **Pricing** - Package cards with functional "Select" buttons that navigate to booking
3. **Portfolio** - Grid gallery with zoom-in functionality
4. **Booking** - Complete booking form with validation and backend integration

### 💼 **Functional Features**
- **Package Selection**: Select buttons on pricing page auto-fill booking notes
- **Social Media Integration**: Functional links to Instagram, Snapchat, WhatsApp, Email
- **Form Validation**: Complete validation on all booking form fields
- **Optional Notes Field**: Users can add additional details to their booking
- **Backend Service**: In-memory booking system (ready for API integration)
- **Success Confirmation**: Beautiful dialog showing booking details after submission
- **Email Notifications**: Framework for sending confirmation emails

### 🎯 **User Experience**
- Smooth animations and transitions
- Hover effects on interactive elements
- Loading states during form submission
- Error handling with user-friendly messages
- Success feedback with detailed booking summary

## 📂 Project Structure

```
lib/
├── pages/
│   ├── homepage_responsive.dart         # Homepage with responsive design
│   ├── bookingpage_responsive.dart      # Booking form with backend integration
│   ├── pricingpage_responsive.dart      # Pricing packages with navigation
│   └── refpage_responsive.dart          # Portfolio gallery
├── widgets/
│   ├── navbar_responsive.dart           # Responsive navbar with mobile menu
│   ├── hover_scale.dart                 # Reusable hover animation widget
│   └── footer.dart                      # Footer component
├── services/
│   └── booking_service.dart             # Backend service for bookings
├── utils/
│   └── responsive.dart                  # Responsive utility helper
└── core/
    └── constants.dart                   # App constants
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd snappixelx
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For web
flutter run -d chrome

# For mobile
flutter run

# For specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

## 📱 Responsive Breakpoints

The app uses the following breakpoints:
- **Mobile**: < 650px
- **Tablet**: 650px - 1100px
- **Desktop**: > 1100px

## 🔧 Configuration

### Social Media Links
Update the social media URLs in `homepage_responsive.dart`:
```dart
final String instagramUrl = 'https://instagram.com/your_handle';
final String snapchatUrl = 'https://snapchat.com/add/your_handle';
final String whatsappNumber = '+233123456789';
final String emailAddress = 'info@yourdomain.com';
```

### Backend Integration

#### Current Setup (In-Memory)
The app currently uses an in-memory booking system in `booking_service.dart`. Bookings are stored in a list and persist only during the app session.

#### Production Setup (API Integration)
To connect to a real backend:

1. **Update the BookingService** in `lib/services/booking_service.dart`:

```dart
class BookingApiService {
  static const String baseUrl = 'https://your-api.com/api';
  
  static Future<Map<String, dynamic>> createBooking(BookingModel booking) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY',
        },
        body: jsonEncode(booking.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Booking created successfully',
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to create booking',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
```

2. **Backend API Requirements**:
   - `POST /api/bookings` - Create new booking
   - `GET /api/bookings` - Get all bookings (optional)
   - `GET /api/bookings/:id` - Get specific booking (optional)
   - `DELETE /api/bookings/:id` - Delete booking (optional)

3. **Expected Request Body**:
```json
{
  "name": "John Doe",
  "phone": "1234567890",
  "email": "john@example.com",
  "eventType": "Wedding",
  "date": "2024-12-25T00:00:00.000Z",
  "notes": "Optional additional details",
  "packageName": "Premium"
}
```

### Email Integration
To send confirmation emails, integrate with an email service:

**Options:**
- SendGrid
- AWS SES
- Mailgun
- Nodemailer (if using Node.js backend)

Update the `sendBookingConfirmation` method in `booking_service.dart` with your email service API.

## 🎨 Customization

### Colors
Update the gradient colors in each page:
```dart
gradient: LinearGradient(
  colors: [
    Color(0xFF06050c),  // Dark purple
    Color(0xFF24108d),  // Purple
    Color(0xFF924e87),  // Pink
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
)
```

### Fonts
The app uses Google Fonts - Playfair Display. To change:
```dart
GoogleFonts.yourFontName(
  // font properties
)
```

### Pricing Packages
Update packages in `pricingpage_responsive.dart`:
```dart
packageCard("Package Name", "₵Price", [
  "Feature 1",
  "Feature 2",
  "Feature 3",
], isMobile, isPopular: true),
```

## 📸 Assets

Place your images in the `assets/` folder:
- `hero.jpg` - Homepage hero image
- `wedding.jpg` - Wedding service card
- `portrait.jpg` - Portrait service card
- `graduation.jpg` - Commercial/Graduation card
- `event.jpg` - Events service card
- `photographer.jpg` - About section photo
- `bookback.jpg` - Booking page background
- `priceback.jpg` - Pricing page background
- Portfolio images: `birthday.jpg`, etc.

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Building for Production

### Web
```bash
flutter build web --release
```
Output: `build/web/`

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🚀 Deployment

### Web Hosting
Deploy to:
- Firebase Hosting
- Netlify
- Vercel
- GitHub Pages

### Mobile
- Google Play Store (Android)
- Apple App Store (iOS)

## 📋 TODO / Future Enhancements

- [ ] Add authentication for admin panel
- [ ] Create admin dashboard to view bookings
- [ ] Implement real-time booking calendar
- [ ] Add payment integration (Stripe, PayPal)
- [ ] Email/SMS notifications
- [ ] Multi-language support
- [ ] Dark mode toggle
- [ ] Image upload for portfolio
- [ ] Customer testimonials section
- [ ] Blog section
- [ ] SEO optimization

## 🐛 Known Issues

None currently. Please report issues in the Issues section.

## 📄 License

[Your License Here]

## 👥 Contributors

[Your Name/Team]

## 📞 Support

For support, email: info@snappixelx.com

---

Built with ❤️ using Flutter