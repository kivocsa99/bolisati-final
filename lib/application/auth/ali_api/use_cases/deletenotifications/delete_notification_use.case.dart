import 'package:bolisati/application/auth/ali_api/use_cases/deletenotifications/delete_notification_use.case.input.dart';
import 'package:bolisati/application/core/use_cases/i.use_case.dart';
import 'package:bolisati/application/provider/user.repository.provider.dart';
import 'package:bolisati/domain/api/failures/api.failures.dart';
import 'package:bolisati/domain/api/user/contracts/i.user.repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deleteNotificationsUseCaseProvider = Provider(
    (ref) => DeleteNotificationsUseCase(authFacade: ref.watch(userProvider)));

class DeleteNotificationsUseCase
    implements IUseCase<DeleteNotificationsInput, dynamic> {
  final IUserRepository? _authFacade;
  DeleteNotificationsUseCase({IUserRepository? authFacade})
      : _authFacade = authFacade;
  @override
  Future<Either<ApiFailures, dynamic>> execute(input) async {
    return await _authFacade!
        .deleteNotifications(id: input.id!, token: input.token!);
  }
}
