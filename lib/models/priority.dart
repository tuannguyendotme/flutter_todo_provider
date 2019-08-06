enum Priority {
  High,
  Medium,
  Low,
}

Priority toPriority(String value) {
  return Priority.values.firstWhere((priority) => priority.toString() == value);
}
