import 'package:flutter/material.dart';
import 'package:password_field_validator/components/validator_item.dart';
import 'package:password_field_validator/validator/enum_valdation.dart';
import 'package:password_field_validator/validator/validator.dart';
import 'package:password_field_validator/validator/validator_message.dart';

class PasswordFieldValidator extends StatefulWidget {
  final int? minLength;
  final int? uppercaseCharCount;
  final int? lowercaseCharCount;
  final int? numericCharCount;
  final int? specialCharCount;

  final Color defaultColor;
  final Color successColor;
  final Color failureColor;
  final TextEditingController controller;

  final String? minLengthMessage;
  final String? uppercaseCharMessage;
  final String? lowercaseMessage;
  final String? numericCharMessage;
  final String? specialCharacterMessage;

  final VoidCallback? onValid;
  final VoidCallback? onInvalid;

  const PasswordFieldValidator({
    Key? key,
    this.minLength,
    this.uppercaseCharCount,
    this.lowercaseCharCount,
    this.numericCharCount,
    this.specialCharCount,
    required this.defaultColor,
    required this.successColor,
    required this.failureColor,
    required this.controller,
    this.minLengthMessage,
    this.uppercaseCharMessage,
    this.lowercaseMessage,
    this.numericCharMessage,
    this.specialCharacterMessage,
    this.onValid,
    this.onInvalid,
  }) : super(key: key);

  @override
  _PasswordFieldValidatorState createState() => _PasswordFieldValidatorState();
}

class _PasswordFieldValidatorState extends State<PasswordFieldValidator> {
  late final Map<Validation, bool> _selectedCondition = {
    if (widget.minLength != null) Validation.atLeast: false,
    if (widget.uppercaseCharCount != null) Validation.uppercase: false,
    if (widget.lowercaseCharCount != null) Validation.lowercase: false,
    if (widget.numericCharCount != null) Validation.numericCharacter: false,
    if (widget.specialCharCount != null) Validation.specialCharacter: false,
  };

  late bool isFirstRun;

  void validate() {
    if (widget.minLength != null) {
      _selectedCondition[Validation.atLeast] = Validator().hasMinimumLength(
        widget.controller.text,
        widget.minLength!,
      );
    }

    if (widget.uppercaseCharCount != null) {
      _selectedCondition[Validation.uppercase] =
          Validator().hasMinimumUppercase(
        widget.controller.text,
        widget.uppercaseCharCount!,
      );
    }

    if (widget.lowercaseCharCount != null) {
      _selectedCondition[Validation.lowercase] =
          Validator().hasMinimumLowercase(
        widget.controller.text,
        widget.lowercaseCharCount!,
      );
    }

    if (widget.numericCharCount != null) {
      _selectedCondition[Validation.numericCharacter] =
          Validator().hasMinimumNumericCharacters(
        widget.controller.text,
        widget.numericCharCount!,
      );
    }

    if (widget.specialCharCount != null) {
      _selectedCondition[Validation.specialCharacter] =
          Validator().hasMinimumSpecialCharacters(
        widget.controller.text,
        widget.specialCharCount!,
      );
    }

    if (mounted) {
      setState(() {});
    }

    if (_selectedCondition.values.every((condition) => condition)) {
      widget.onValid?.call();
    } else {
      widget.onInvalid?.call();
    }
  }

  @override
  void initState() {
    super.initState();
    isFirstRun = true;

    widget.controller.addListener(_textControllerListener);
  }

  void _textControllerListener() {
    isFirstRun = false;
    validate();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _selectedCondition.entries.map((entry) {
        int conditionValue = 0;
        String conditionMessage = '';
        if (entry.key == Validation.atLeast && widget.minLength != null) {
          conditionValue = widget.minLength!;
          conditionMessage = widget.minLengthMessage ??
              validatorMessage.entries
                  .firstWhere((element) => element.key == Validation.atLeast)
                  .value
                  .toString();
        }
        if (entry.key == Validation.uppercase &&
            widget.uppercaseCharCount != null) {
          conditionValue = widget.uppercaseCharCount!;
          conditionMessage = widget.uppercaseCharMessage ??
              validatorMessage.entries
                  .firstWhere((element) => element.key == Validation.uppercase)
                  .value
                  .toString();
        }
        if (entry.key == Validation.lowercase &&
            widget.lowercaseCharCount != null) {
          conditionValue = widget.lowercaseCharCount!;
          conditionMessage = widget.lowercaseMessage ??
              validatorMessage.entries
                  .firstWhere((element) => element.key == Validation.lowercase)
                  .value
                  .toString();
        }
        if (entry.key == Validation.numericCharacter &&
            widget.numericCharCount != null) {
          conditionValue = widget.numericCharCount!;
          conditionMessage = widget.numericCharMessage ??
              validatorMessage.entries
                  .firstWhere(
                      (element) => element.key == Validation.numericCharacter)
                  .value
                  .toString();
        }
        if (entry.key == Validation.specialCharacter &&
            widget.specialCharCount != null) {
          conditionValue = widget.specialCharCount!;
          conditionMessage = widget.specialCharacterMessage ??
              validatorMessage.entries
                  .firstWhere(
                      (element) => element.key == Validation.specialCharacter)
                  .value
                  .toString();
        }
        return ValidatorItemWidget(
          conditionMessage,
          conditionValue,
          isFirstRun
              ? widget.defaultColor
              : entry.value
                  ? widget.successColor
                  : widget.failureColor,
          entry.value,
        );
      }).toList(),
    );
  }
}
