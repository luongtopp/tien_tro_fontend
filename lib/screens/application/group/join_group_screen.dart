import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../blocs/group_bloc/group_blocs.dart';
import '../../../blocs/group_bloc/group_events.dart';
import '../../../blocs/group_bloc/group_states.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../generated/l10n.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_route.dart';
import '../../../utils/loading_overlay.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/appbars/custom_appbar.dart';
import '../../../widgets/buttons/custom_button.dart';

class JoinGroupScreen extends StatefulWidget {
  final UserModel user;
  const JoinGroupScreen({super.key, required this.user});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = widget.user.id;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submitJoinGroup() {
    userId = widget.user.id;

    if (_formKey.currentState!.validate()) {
      context.read<GroupBloc>().add(JoinGroup(
            userId: userId!,
            code: _codeController.text,
          ));
    }
  }

  void _handleGroupState(BuildContext context, GroupState state) {
    final s = S.of(context);
    switch (state) {
      case GroupValidating():
        LoadingOverlay.show(context);
        break;
      case GroupActionCompleted():
        LoadingOverlay.hide();
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.ZOOM_DRAWER_SCREEN,
          (Route<dynamic> route) => false,
          arguments: [state.user, state.userGroups],
        );
        break;
      case GroupError():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.error, type: SnackBarType.error);
        break;
      default:
        LoadingOverlay.hide();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        _handleGroupState(context, state);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: CustomAppBar(
            title: s.joinGroup,
            leadingIcon: Icons.arrow_back_ios_new_rounded,
            iconColor: AppColors.primaryColor,
            func: () => Navigator.of(context).pop(),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      Text(
                        s.enterGroupCode,
                        style: AppTextStyles.subheading,
                      ),
                      SizedBox(height: 16.h),
                      _buildPinCodeTextField(s),
                      SizedBox(height: 24.h),
                      _buildJoinButton(s),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinCodeTextField(S s) {
    return PinCodeTextField(
      dialogConfig: DialogConfig(
        dialogTitle: s.groupCode,
        dialogContent: s.doYouWantToPasteTheCode,
        affirmativeText: s.pasteCode,
        negativeText: s.cancel,
      ),
      pastedTextStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return s.groupCodeCannotBeEmpty;
        }
        return null;
      },
      animationType: AnimationType.fade,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      controller: _codeController,
      appContext: context,
      length: 6,
      textStyle:
          AppTextStyles.subheading.copyWith(color: AppColors.primaryColor),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10.r),
        fieldHeight: 50.h,
        fieldWidth: 50.w,
        inactiveColor: AppColors.borderImageColor,
        activeColor: AppColors.primaryColor,
        selectedColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildJoinButton(S s) {
    return CustomButton(
      text: s.joinGroup,
      width: 288.w,
      height: 85.h,
      color: AppColors.primaryColor,
      borderRadius: 67.r,
      onTap: _submitJoinGroup,
      textStyle: AppTextStyles.filledButton,
    );
  }
}
