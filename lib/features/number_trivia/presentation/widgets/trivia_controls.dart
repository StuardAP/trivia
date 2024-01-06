import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import 'widgets.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final inputController = TextEditingController();
  String inputStr = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          appInputController: inputController,
          appTextFieldOnChanged: (value) {
            inputStr = value;
          },
          appTextFieldOnSubmitted: (_) {
            _dispatchConcrete();
          },
        ),
        const SizedBox(height: 16),
        Row(children: [
          AppButton(
              appButtonText: 'Search',
              bg: Colors.teal,
              fg: Colors.white70,
              appButtonOnPressed: _dispatchConcrete),
          const SizedBox(width: 16),
          AppButton(
              appButtonText: 'Random',
              bg: Colors.white70,
              fg: Colors.black87,
              appButtonOnPressed: _dispatchRandom),
        ])
      ],
    );
  }

  void _dispatchConcrete() {
    inputController.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void _dispatchRandom() {
    inputController.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
