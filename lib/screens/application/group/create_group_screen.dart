import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
import '../../../widgets/textfields/custom_textfield.dart';

class CreateGroupScreen extends StatefulWidget {
  final UserModel user;
  const CreateGroupScreen({super.key, required this.user});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = widget.user.id;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<GroupBloc>().add(AddGroup(
            userId: userId!,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
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
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: s.createGroup,
          leadingIcon: Icons.arrow_back_ios_new_rounded,
          iconColor: AppColors.primaryColor,
          func: () => Navigator.of(context).pop(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 89.h),
                  _buildNameField(s),
                  SizedBox(height: 24.h),
                  _buildDescriptionField(s),
                  SizedBox(height: 48.h),
                  _buildSubmitButton(s),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(S s) {
    return CustomTextField(
      controller: _nameController,
      hintText: s.groupName,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.group,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return s.groupNameCannotBeEmpty;
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(S s) {
    return CustomTextField(
      controller: _descriptionController,
      hintText: s.description,
      textInputAction: TextInputAction.newline,
      prefixIcon: Icons.description,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      validator: (value) {
        if (value != null && value.trim().length > 100) {
          return s.descriptionCannotExceed100Characters;
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(S s) {
    return CustomButton(
      text: s.createGroup,
      width: 288.w,
      height: 85.h,
      color: AppColors.primaryColor,
      borderRadius: 67.r,
      onTap: userId != null ? _submitForm : null,
      textStyle: AppTextStyles.filledButton,
    );
  }
}
