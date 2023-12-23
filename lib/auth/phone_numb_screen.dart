import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purefarm/api_helper.dart';
import 'package:purefarm/auth/auth_button.dart';
import 'package:purefarm/auth/verification_screen.dart';
import 'package:flutter/services.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  ApiHelper apiHelper = ApiHelper();
  TextEditingController mobileNumberController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Get started',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              TextFormField(
                controller: mobileNumberController,
                enabled: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(
                    color: Colors.green[300],
                  ),
                  prefixText: '+91\t',
                  hintText: 'Enter mobile number',
                  hintStyle: GoogleFonts.didactGothic(),
                ),
              ),
              const Spacer(),
              AuthButton(
                title: 'Continue',
                onPressed: () => _handleContinueButton(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'By continuing, you agree to our\n',
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinueButton() async {
    String mobileNumber = mobileNumberController.text;

    // Check if the mobile number has 10 digits
    if (mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool otpSent = await apiHelper.sendOTP(mobileNumber);
    if (otpSent) {
      Navigator.push(
        scaffoldKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(mobileNumber: mobileNumber),
        ),
      );
    }
  }
}
