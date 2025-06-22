import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'all_workshops_state.dart';

class AllWorkshopsCubit extends Cubit<AllWorkshopsState> {
  AllWorkshopsCubit() : super(AllWorkshopsInitial());
}
