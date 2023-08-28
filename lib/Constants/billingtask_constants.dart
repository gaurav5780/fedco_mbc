// Constants for Task status IDs -  Integers:

// class TaskStatusID {
//   static const int created = 1;
//   static const int inProgress = 2;
//   static const int delayed = 3;
//   static const int completed = 4;
// }

// Constants for Task status names -  Strings:

// class TaskStatusName {
//   static const String created = 'Created';
//   static const String inProgress = 'In progress';
//   static const String delayed = 'Delayed';
//   static const String completed = 'Completed';
// }

// Returns the String name for an Task Status from its int ID value:

// String getTaskStatusfromInt(statusID) {
//   switch (statusID) {
//     case TaskStatusID.created:
//       return TaskStatusName.created;
//     case TaskStatusID.inProgress:
//       return TaskStatusName.inProgress;
//     case TaskStatusID.delayed:
//       return TaskStatusName.delayed;
//     case TaskStatusID.completed:
//       return TaskStatusName.completed;
//     default:
//       return 'Unclassified';
//   }
// }

// // Returns the int ID value for an Action Status from its String name:

// int getActionStatusfromString(actionName) {
//   switch (actionName) {
//     case TaskStatusName.created:
//       return TaskStatusID.created;
//     case TaskStatusName.inProgress:
//       return TaskStatusID.inProgress;
//     case TaskStatusName.delayed:
//       return TaskStatusID.delayed;
//     case TaskStatusName.completed:
//       return TaskStatusID.completed;
//     default:
//       return 0;
//   }
// }
