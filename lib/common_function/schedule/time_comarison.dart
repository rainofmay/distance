bool timeComparison(DateTime start, DateTime end, bool boolValue) {
  if (boolValue == false) {  // 시간 비활성화하면 무조건 true 리턴
    return true;
  }
  if (start.hour < end.hour) {
    return true;
  } else if (start.hour == end.hour) {
    if (start.minute < end.minute) {
      return true;
    }
  }
  return false;
}