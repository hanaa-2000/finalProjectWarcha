import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcha_final_progect/features/client/home/data/appointment_model.dart';
import 'package:warcha_final_progect/features/workshop/home/data/workshop_home_repo.dart';

part 'workshop_home_state.dart';

class WorkshopHomeCubit extends Cubit<WorkshopHomeState> {
  WorkshopHomeCubit(this.repository) : super(WorkshopHomeInitial()){
    getPeople();
    loadSelectedNames();
  }
  final WorkshopHomeRepo repository;
  List<String> selectedNames = [];

 var userId=FirebaseAuth.instance.currentUser!.uid;
  Future<void> loadSelectedNames() async {
    final prefs = await SharedPreferences.getInstance();
    selectedNames = prefs.getStringList('selectedNames') ?? [];
    emit(MechanicalLoaded(selectedNames)); // أرسل الحالة بعد تحميل الأسماء
  }



  Future<void> addPerson(String name) async {
    try {
      await repository.addPerson(name);
      getPeople(); // تحديث القائمة بعد الإضافة
    } catch (e) {
      emit(MechanicalError(e.toString()));
    }
  }

  // Future<void> deletePerson(String docId) async {
  //   try {
  //     await repository.deletePerson(docId);
  //     getPeople(); // تحديث القائمة بعد الحذف
  //   } catch (e) {
  //     emit(MechanicalError(e.toString()));
  //   }
  // }
  Future<void> deletePerson(String name) async {
    try {
      await repository.deletePersonByName(name);
      getPeople();
    } catch (e) {
      emit(MechanicalError(e.toString()));
    }
  }

  void getPeople() {
    emit(MechanicalLoading());
    repository.getPeople().listen((people) {
      emit(MechanicalLoaded(people));
    });
  }

  void toggleSelection(String name) {
    if (selectedNames.contains(name)) {
      selectedNames.remove(name);
      getPeople();
    } else {
      selectedNames.add(name);
      getPeople();
    }
    _saveSelectedNames(); // حفظ الأسماء المختارة
    emit(MechanicalLoaded(selectedNames));
  }



  Future<void> _saveSelectedNames() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedNames', selectedNames);
  }


  Future<void> fetchUserOrders() async {
    try {
      emit(OrdersLoading());
      print("Fetching orders for user: ${FirebaseAuth.instance.currentUser!.uid}");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('workshopId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No active bookings found for user");
        emit(NoOrderFound());
        return;
      }

      final orders = querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
      print("Orders loaded: ${orders.length} bookings found");
      emit(OrderLoaded(orders));
    } catch (e) {
      print("Error fetching orders: $e");
      emit(OrdersError( e.toString()));
    }
  }


}
