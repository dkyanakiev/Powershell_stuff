﻿function Convert-FromEpochMillisecondsToDateTime ($UnixDate) {
   [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddMilliseconds($UnixDate))
}