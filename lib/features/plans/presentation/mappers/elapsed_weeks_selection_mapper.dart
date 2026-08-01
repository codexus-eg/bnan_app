int? resolveInitialPlanWeek({
  required int weeksCount,
  required int currentWeek,
}) {
  if (weeksCount <= 0) return null;
  if (currentWeek >= 1 && currentWeek <= weeksCount) return currentWeek;
  return 1;
}
