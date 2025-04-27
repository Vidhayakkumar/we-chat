import 'package:dartz/dartz.dart';

import '../../../backend/repository/auth/repo_auth.dart';
import '../../../backend/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../models/auth/signin_user_req.dart';

class SignInUseCase implements UseCase<Either,SignInUserReq>{
  @override
  Future<Either> call({SignInUserReq? params})async {
    return await sl<AuthRepository>().signin(params!);
  }

}