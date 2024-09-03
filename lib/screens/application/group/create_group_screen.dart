import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/group_bloc/group_bloc.dart';
import '../../../blocs/group_bloc/group_event.dart';
import '../../../blocs/group_bloc/group_state.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../routes/app_route.dart';
import '../../../utils/loading_overlay.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/appbars/appbar_custom.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/textfields/custom_textfield.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleGroupState(BuildContext context, GroupState state) {
    switch (state) {
      case GroupValidating():
        LoadingOverlay.show(context);
        break;
      case GroupFailure():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.error, type: SnackBarType.failed);
        break;
      case GroupError():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.error, type: SnackBarType.error);
        break;
      case CreateGroupSuccess():
        LoadingOverlay.hide();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.ZOOM_DRAWER_SCREEN,
            (Route<dynamic> route) => false,
            arguments: [state.groups, state.user],
          );
        });
        break;
      default:
        LoadingOverlay.hide();
        break;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<GroupBloc>().add(AddGroup(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: _handleGroupState,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: appBarCustom(
          context: context,
          title: "Tạo nhóm",
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
                  _buildNameField(),
                  SizedBox(height: 24.h),
                  _buildDescriptionField(),
                  SizedBox(height: 48.h),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      hintText: 'Tên nhóm',
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.group,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Tên nhóm không được để trống';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
      controller: _descriptionController,
      hintText: 'Mô tả',
      textInputAction: TextInputAction.newline,
      prefixIcon: Icons.description,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      validator: (value) {
        if (value != null && value.trim().length > 100) {
          return 'Mô tả không được quá 100 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: 'Tạo nhóm',
      width: 288.w,
      height: 85.h,
      color: AppColors.primaryColor,
      borderRadius: 67.r,
      onTap: _submitForm,
      textStyle: AppTextStyles.filledButton,
    );
  }
}
