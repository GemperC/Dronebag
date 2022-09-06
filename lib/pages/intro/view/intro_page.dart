import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        showBackButton: true,
        showSkipButton: true,
        showNextButton: true,
        next: Text('Next'),
        skip: Text('Skip'),
        done: Text('Done'),
        onDone:() {
          
        },
        onSkip: () {
  
        },
        pages: [

        ],
        ),
      );
  }
}
