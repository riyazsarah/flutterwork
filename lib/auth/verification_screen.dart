import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:purefarm/auth/auth_button.dart';
import 'package:purefarm/api_helper.dart';
import 'package:purefarm/auth_provider.dart';

class VerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const VerificationScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  int retryTimerSeconds = 30;
  int maxRetryAttempts = 2;
  int currentRetryAttempt = 0;
  bool isRetryClickable = false;
  bool showContactMessage = false;

  final ApiHelper apiHelper = ApiHelper();

  @override
  void initState() {
    super.initState();
    startRetryTimer();
  }

  void startRetryTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (retryTimerSeconds > 0) {
          setState(() {
            retryTimerSeconds--;
          });
        } else {
          setState(() {
            isRetryClickable = true;
            currentRetryAttempt++;
            retryTimerSeconds = 30; // Reset timer for the next attempt
          });

          // Stop the timer after the maximum number of retry attempts
          if (currentRetryAttempt >= maxRetryAttempts) {
            timer.cancel();
            setState(() {
              showContactMessage = true;
              isRetryClickable = false;
            });
          }
        }
      } else {
        timer.cancel(); // Ensure the timer is canceled if the widget is no longer mounted
      }
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'OTP Verification',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: RichText(
                text: TextSpan(
                  text: 'We have sent verification code to ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: '+91-${widget.mobileNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                6,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.green),
                  ),
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        // Move focus to the next TextField when a digit is entered
                        if (index < 5) {
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        } else {
                          // If the last digit is entered, unfocus the current TextField
                          focusNodes[index].unfocus();
                        }
                      }
                    },
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: isRetryClickable
                    ? ElevatedButton(
                        onPressed: () async {
                          if (mounted) {
                            setState(() {
                              isRetryClickable = false;
                            });

                            // Trigger sendOTP function here
                            await apiHelper.sendOTP(widget.mobileNumber);

                            // Use mounted check before triggering the retry timer
                            if (mounted) {
                              startRetryTimer();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        child: const Text('Retry'),
                      )
                    : showContactMessage
                        ? const Text(
                            'There seems to be some issue with OTP service. Contact 8282830830',
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            'Retry in $retryTimerSeconds seconds',
                            style: TextStyle(
                              color: theme.disabledColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
              ),
            ),
            const Spacer(),
            AuthButton(
              title: 'Verify and Proceed',
              onPressed: () => verifyAndProceed(context, theme.colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  void verifyAndProceed(BuildContext context, ColorScheme colorScheme) async {
    // Your logic to verify and proceed
    String completeOTP = controllers.map((controller) => controller.text).join();
    print('Complete OTP: $completeOTP');

    if (completeOTP.length < 6) {
      // Show a snackbar if the user hasn't entered all 6 digits
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Proceed with your verification logic
      String response = await ApiHelper.verifyOTP(completeOTP, widget.mobileNumber);
      logger.d(response);
      
          }
  }
}
