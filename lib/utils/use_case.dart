
import 'package:devant_components/utils/typedefs.dart';

/// Generic domain use-case contract. Implementations hide repository details.

abstract class UseCase<Params, Result> {
  FutureEither<Result> call(Params params);
}

/// Empty params as a record — use when a use case needs no input.
typedef NoParams = ();
