import '../../repositories/payment_repository.dart';
import '../../entities/payment_result_entity.dart';

class TopupUsecase {
  final PaymentRepository _repository;
  TopupUsecase(this._repository);
  Future<({double balance, double amount})> call(double amount) =>
      _repository.topup(amount);
}