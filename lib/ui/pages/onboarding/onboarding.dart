// @dart=2.9

import 'dart:ui';
import 'package:chat/state_mangement/onboarding/onboarding_cubit.dart';
import 'package:chat/state_mangement/onboarding/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/colors.dart';
import 'package:chat/state_mangement/onboarding/profile_image_cubit.dart';
import 'package:chat/ui/widgets/onboarding/logo.dart';
import 'package:chat/ui/widgets/onboarding/profilupload.dart';
import 'package:chat/ui/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'onboarding_router.dart';

class Onboarding extends StatefulWidget {
  final IOnboardingRouter router;
  const Onboarding(this.router);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String _username = '';
  String _city = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileUpload(),
              Spacer(flex: 1),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomTextField(
                  hint: 'Enter Your Name?',
                  height: 45.0,
                  onchanged: (val) {
                    _username = val;
                  },
                  inputAction: TextInputAction.done,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomTextField(
                  hint: 'Enter Your City?',
                  height: 45.0,
                  onchanged: (val) {
                    _city = val;
                  },
                  inputAction: TextInputAction.done,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final error = _checkInputs();
                    if (error.isNotEmpty) {
                      final snackBar = SnackBar(
                        content: Text(
                          error,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    await _connectSession();
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      'Start Chatting!',
                      style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0))),
                ),
              ),
              Spacer(),
              BlocConsumer<OnboardingCubit, OnboardingState>(
                builder: (context, state) => state is Loading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
                listener: (_, state) {
                  if (state is OnboardingSuccess)
                    widget.router.onSessionSuccess(context, state.user);
                },
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  // _logo(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Text(
  //         'Chat',
  //         style: Theme.of(context)
  //             .textTheme
  //             .headline4
  //             .copyWith(fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(
  //         width: 8.0,
  //       ),
  //       Text(
  //         'Chat',
  //         style: Theme.of(context)
  //             .textTheme
  //             .headline4
  //             .copyWith(fontWeight: FontWeight.bold),
  //       ),
  //     ],
  //   );
  // }

  _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<OnboardingCubit>().connect(_username,_city, profileImage);
  }

  String _checkInputs() {
    var error = '';
    if (_username.isEmpty) error = 'Enter display name';
    if (_city.isEmpty) error = '\n'+'Enter display city';
    if (context.read<ProfileImageCubit>().state == null)
      error = error + '\n' + 'Upload profile image';

    return error;
  }
}
