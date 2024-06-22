bool timeComparison(DateTime start, DateTime end, bool boolValue) {
  if (boolValue == false) {  // 시간 비활성화하면 무조건 true 리턴
    return true;
  }

  if (start.year < end.year ||
      (start.year == end.year && start.month < end.month) ||
      (start.year == end.year && start.month == end.month && start.day < end.day)) {
    return true;
  }

  // 날짜가 동일하다면 시간을 비교
  if (start.hour < end.hour ||
      (start.hour == end.hour && start.minute < end.minute)) {
    return true;
  }
  // 그 외의 경우에는 종료날짜가 시작날짜보다 이전이므로 false를 반환
  return false;
}