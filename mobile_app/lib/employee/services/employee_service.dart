import '../models/employee_model.dart';

class EmployeeService {

  static List<Employee> getEmployees() {

    return [

      Employee(
        id: 1,
        name: "Rahul Sharma",
        email: "rahul@gmail.com",
        department: "IT",
      ),

      Employee(
        id: 2,
        name: "Priya Patil",
        email: "priya@gmail.com",
        department: "HR",
      ),

      Employee(
        id: 3,
        name: "Amit Joshi",
        email: "amit@gmail.com",
        department: "Finance",
      ),

      Employee(
        id: 4,
        name: "Sneha Kulkarni",
        email: "sneha@gmail.com",
        department: "Sales",
      ),

      Employee(
        id: 5,
        name: "Akash Patil",
        email: "akash@gmail.com",
        department: "Admin",
      ),

    ];
  }
}