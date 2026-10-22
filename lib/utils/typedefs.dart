import 'package:devant_components/utils/failure.dart';
import 'package:fpdart/fpdart.dart';


typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef StreamEither<T> = Stream<Either<Failure, T>>;
