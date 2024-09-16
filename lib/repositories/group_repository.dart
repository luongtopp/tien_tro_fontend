import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense_model.dart';
import '../models/group_model.dart';
import '../models/member_model.dart';
import '../exceptions/firebase_exception.dart';
import 'auth_repository.dart';
import 'user_repository.dart';

class GroupRepository {
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  GroupRepository({
    FirebaseFirestore? firestore,
    UserRepository? userRepository,
    AuthRepository? authRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _userRepository = userRepository ?? UserRepository(),
        _authRepository = authRepository ?? AuthRepository();

  Future<void> createGroup(GroupModel group) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('groups').add(group.toMap());
      await docRef.update({'id': docRef.id});
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tạo nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tạo nhóm: $e');
    }
  }

  Future<GroupModel> joinGroup(String code, MemberModel member) async {
    try {
      final groupDoc = await _firestore
          .collection('groups')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (groupDoc.docs.isEmpty) {
        throw FirebaseException(code: 'not-found', plugin: 'group');
      }
      final groupData = GroupModel.fromFirestore(groupDoc.docs.first);
      final members = groupData.members;
      if (members.any((m) => m.id == member.id)) {
        throw FirebaseException(code: 'already-joined', plugin: 'group');
      }
      await _firestore.collection('groups').doc(groupDoc.docs.first.id).update({
        'members': FieldValue.arrayUnion([member.toMap()]),
        'memberCount': FieldValue.increment(1),
      });

      final updatedGroupDoc = await _firestore
          .collection('groups')
          .doc(groupDoc.docs.first.id)
          .get();

      final updatedGroupData = GroupModel.fromFirestore(updatedGroupDoc);
      return updatedGroupData;
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tham gia nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tham gia nhóm: $e');
    }
  }

  Future<GroupModel> updateGroup(GroupModel group) async {
    try {
      await _firestore.collection('groups').doc(group.id).update(group.toMap());
      final updatedGroupDoc =
          await _firestore.collection('groups').doc(group.id).get();
      return GroupModel.fromFirestore(updatedGroupDoc);
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi cập nhật nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi cập nhật nhóm: $e');
    }
  }

  Future<GroupModel> deleteGroup(String groupId) async {
    try {
      await _firestore.collection('groups').doc(groupId).delete();

      List<GroupModel> userGroups = await getUserGroups(_authRepository.uid!);

      if (userGroups.isNotEmpty) {
        return userGroups.first;
      } else {
        throw Exception('Không còn nhóm nào sau khi xóa');
      }
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi xóa nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi xóa nhóm: $e');
    }
  }

  Future<GroupModel> getGroupById(String groupId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('groups').doc(groupId).get();

      if (!doc.exists) {
        throw FirebaseException(plugin: 'firestore', code: 'not-found');
      }

      GroupModel group = GroupModel.fromFirestore(doc);

      // Cập nhật lastAccessDate cho thành viên hiện tại
      String currentUserId = _authRepository.uid!;
      List<MemberModel> updatedMembers = group.members.map((member) {
        if (member.id == currentUserId) {
          return member.copyWith(lastAccessDate: DateTime.now());
        }
        return member;
      }).toList();

      // Cập nhật group với danh sách thành viên mới
      GroupModel updatedGroup = group.copyWith(members: updatedMembers);
      await _firestore
          .collection('groups')
          .doc(groupId)
          .update(updatedGroup.toMap());

      return updatedGroup;
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tìm nạp nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tìm nạp nhóm: $e');
    }
  }

  Future<List<GroupModel>> getAllGroups() async {
    try {
      final groupsQuery = await _firestore.collection('groups').get();
      return groupsQuery.docs
          .map((doc) => GroupModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tìm nạp tất cả nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tìm nạp tất cả nhóm: $e');
    }
  }

  Future<GroupModel?> getGroupByCode(String code) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('groups')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return GroupModel.fromFirestore(querySnapshot.docs.first);
      } else {
        throw FirebaseException(plugin: 'firestore', code: 'not-found-code');
      }
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tìm bằng mã nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tìm bằng mã nhóm: $e');
    }
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      List<GroupModel> resultGroups = [];

      QuerySnapshot querySnapshot = await _firestore.collection('groups').get();
      for (var doc in querySnapshot.docs) {
        GroupModel groupData = GroupModel.fromFirestore(doc);
        List<MemberModel> members = groupData.members;
        for (var member in members) {
          if (member.id == userId) {
            resultGroups.add(groupData);
            break;
          }
        }
      }

      final userDoc = await _userRepository.getUserById(userId);
      final userData = userDoc?.toMap();
      if (userData == null) {
        return [];
      }

      resultGroups.sort((a, b) {
        DateTime? getLastAccessDate(GroupModel group) {
          return group.members
              .map((member) => member.lastAccessDate)
              .where((date) => date != null)
              .reduce((a, b) => a!.isAfter(b!) ? a : b);
        }

        final aLastAccess = getLastAccessDate(a);
        final bLastAccess = getLastAccessDate(b);

        if (aLastAccess == null && bLastAccess == null) return 0;
        if (aLastAccess == null) return 1;
        if (bLastAccess == null) return -1;

        return bLastAccess.compareTo(aLastAccess);
      });
      return resultGroups;
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi kiểm tra nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi kiểm tra nhóm: $e');
    }
  }

  Stream<List<GroupModel>> streamUserGroups(String userId) {
    return _firestore
        .collection('groups')
        .snapshots()
        .asyncMap((snapshot) async {
      List<GroupModel> resultGroups = [];

      for (var doc in snapshot.docs) {
        GroupModel groupData = GroupModel.fromFirestore(doc);
        List<MemberModel> members = groupData.members;
        for (var member in members) {
          if (member.id == userId) {
            resultGroups.add(groupData);
            break;
          }
        }
      }

      final userDoc = await _userRepository.getUserById(userId);
      final userData = userDoc?.toMap();
      if (userData == null) {
        return [];
      }

      resultGroups.sort((a, b) {
        DateTime? getLastAccessDate(GroupModel group) {
          return group.members
              .map((member) => member.lastAccessDate)
              .where((date) => date != null)
              .reduce((a, b) => a!.isAfter(b!) ? a : b);
        }

        final aLastAccess = getLastAccessDate(a);
        final bLastAccess = getLastAccessDate(b);

        if (aLastAccess == null && bLastAccess == null) return 0;
        if (aLastAccess == null) return 1;
        if (bLastAccess == null) return -1;

        return bLastAccess.compareTo(aLastAccess);
      });
      return resultGroups;
    });
  }

  Future<double> getTotalGroupExpense(String groupId) async {
    try {
      final groupDoc = await _firestore.collection('groups').doc(groupId).get();
      if (!groupDoc.exists) {
        throw FirebaseException(plugin: 'firestore', code: 'not-found');
      }
      final groupData = GroupModel.fromFirestore(groupDoc);
      double totalExpense = 0.0;
      for (var member in groupData.members) {
        totalExpense += member.totalExpenseAmount;
      }
      return totalExpense;
    } on FirebaseException catch (e) {
      throw handleException(
          e: e,
          defaultMessage: 'Lỗi lấy tổng chi phí của nhóm',
          plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi lấy tổng chi phí của nhóm: $e');
    }
  }

  Future<void> removeMemberFromGroup(String groupId, String memberId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayRemove([memberId]),
        'memberCount': FieldValue.increment(-1),
      });
    } on FirebaseException catch (e) {
      throw handleException(
          e: e,
          defaultMessage: 'Lỗi xóa thành viên khỏi nhóm',
          plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi xóa thành viên khỏi nhóm: $e');
    }
  }

  Future<String> generateUniqueGroupCode() async {
    const int codeLength = 6;
    const int maxAttempts = 10;
    int attempts = 0;

    while (attempts < maxAttempts) {
      String code = _generateRandomCode(codeLength);
      bool isUnique = await _isCodeUnique(code);

      if (isUnique) {
        return code;
      }

      attempts++;
    }

    throw Exception('Không thể tạo mã nhóm duy nhất sau $maxAttempts lần thử');
  }

  String _generateRandomCode(int length) {
    const String digits = '0123456789';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => digits.codeUnitAt(random.nextInt(digits.length)),
      ),
    );
  }

  Future<bool> _isCodeUnique(String code) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('groups')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      throw Exception('Lỗi kiểm tra tính duy nhất của mã: $e');
    }
  }

  // Future<void> addExpenseToGroup(String groupId, ExpenseModel expense) async {
  //   try {
  //     DocumentReference groupRef = _firestore.collection('groups').doc(groupId);

  //     await _firestore.runTransaction((transaction) async {
  //       DocumentSnapshot groupSnapshot = await transaction.get(groupRef);
  //       if (!groupSnapshot.exists) {
  //         throw Exception('Nhóm không tồn tại');
  //       }

  //       Map<String, dynamic> groupData =
  //           groupSnapshot.data() as Map<String, dynamic>;
  //       List<dynamic> members = groupData['members'];

  //       // Cập nhật totalExpenseAmount và balance cho các thành viên
  //       for (var member in members) {
  //         if (expense.byPeople.any((e) => e.id == member['id'])) {
  //           member['totalExpenseAmount'] =
  //               (member['totalExpenseAmount'] ?? 0.0) + expense.amount;
  //           member['balance'] = (member['balance'] ?? 0.0) + expense.amount;
  //         } else {
  //           double shareAmount = expense.amount / members.length;
  //           member['balance'] = (member['balance'] ?? 0.0) - shareAmount;
  //         }
  //       }

  //       transaction.update(groupRef, {
  //         'expenses': FieldValue.arrayUnion([expense.toMap()]),
  //         'members': members,
  //       });
  //     });
  //   } on FirebaseException catch (e) {
  //     throw handleException(
  //       e: e,
  //       defaultMessage: 'Lỗi thêm chi phí vào nhóm',
  //       plugin: 'group',
  //     );
  //   } catch (e) {
  //     throw Exception('Lỗi thêm chi phí vào nhóm: $e');
  //   }
  // }
}
