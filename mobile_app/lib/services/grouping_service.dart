import '../models/employee_model.dart';

class GroupingService {
  GroupingService._();

  static List<List<EmployeeModel>>
      createGroups(
    List<EmployeeModel> employees, {
    int groupSize = 4,
  }) {
    final groups =
        <List<EmployeeModel>>[];

    for (int i = 0;
        i < employees.length;
        i += groupSize) {
      groups.add(
        employees.sublist(
          i,
          i + groupSize >
                  employees.length
              ? employees.length
              : i + groupSize,
        ),
      );
    }

    return groups;
  }
}