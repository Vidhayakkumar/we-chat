import 'package:dartz/dartz.dart';

import '../../../backend/repository/auth/repo_auth.dart';
import '../../../backend/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../models/auth/create_user_req.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq>{

  @override
  Future<Either> call({CreateUserReq? params}) async{
  return await sl<AuthRepository>().signup(params!);
  }

}