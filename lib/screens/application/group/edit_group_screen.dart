import 'package:chia_se_tien_sinh_hoat_tro/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/group_bloc/group_blocs.dart';
import '../../../blocs/group_bloc/group_events.dart';
import '../../../blocs/group_bloc/group_states.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../generated/l10n.dart';
import '../../../models/member_model.dart';
import '../../../routes/app_route.dart';
import '../../../utils/loading_overlay.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/appbars/custom_appbar.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/textfields/custom_textfield.dart';

class EditGroupScreen extends StatefulWidget {
  final GroupModel group;
  const EditGroupScreen({super.key, required this.group});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  late GroupModel groupModel;
  late List<MemberModel> originalMembers;
  late List<MemberModel> currentMembers;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    groupModel = widget.group;
    originalMembers = List.from(groupModel.members);
    currentMembers = []; // Initialize as an empty list
    _nameController.text = groupModel.name;
    _descriptionController.text = groupModel.description ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      groupModel = groupModel.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        members: currentMembers,
      );
      context.read<GroupBloc>().add(UpdateGroup(groupModel));
    }
  }

  void _toggleMember(MemberModel member) {
    setState(() {
      if (currentMembers.contains(member)) {
        currentMembers.remove(member);
      } else {
        currentMembers.add(member);
      }
    });
  }

  void _handleGroupState(BuildContext context, GroupState state) {
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
          title: s.editGroup,
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
                  SizedBox(height: 35.h),
                  _buildNameField(),
                  SizedBox(height: 24.h),
                  _buildDescriptionField(),
                  SizedBox(height: 24.h),
                  _buildMembersList(),
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
    final s = S.of(context);
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

  Widget _buildDescriptionField() {
    final s = S.of(context);
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

  Widget _buildMembersList() {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.selectMemberToDelete,
          style: AppTextStyles.bodyRegular,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 300.h,
          child: ShaderMask(
            shaderCallback: (Rect rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                ],
                stops: [0.0, 0.7, 0.8, 0.99, 1],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 100.h),
              itemCount: originalMembers
                  .where((member) => member.role != "owner")
                  .length,
              itemBuilder: (context, index) {
                final member = originalMembers
                    .where((member) => member.role != "owner")
                    .toList()[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: AppColors.primaryColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  color: AppColors.backgroundColor,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: member.avatarUrl != null
                          ? NetworkImage(member.avatarUrl!)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                      radius: 20,
                    ),
                    title: Text(member.name, style: AppTextStyles.bodyRegular),
                    subtitle: formattedAmount(member.balance),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: currentMembers.contains(member)
                            ? AppColors.errorColor
                            : Colors.grey,
                      ),
                      onPressed: () {
                        _toggleMember(member);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final s = S.of(context);
    return CustomButton(
      text: s.updateGroup,
      width: 288.w,
      height: 85.h,
      color: AppColors.primaryColor,
      borderRadius: 67.r,
      onTap: _submitForm,
      textStyle: AppTextStyles.filledButton,
    );
  }
}
