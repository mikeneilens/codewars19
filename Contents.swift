/*
Your task in order to complete this Kata is to write a function which formats a duration, given as a number of seconds, in a human-friendly way.

The function must accept a non-negative integer. If it is zero, it just returns "now". Otherwise, the duration is expressed as a combination of years, days, hours, minutes and seconds.

It is much easier to understand with an example:

formatDuration(62)    // returns "1 minute and 2 seconds"
formatDuration(3662)  // returns "1 hour, 1 minute and 2 seconds"
For the purpose of this Kata, a year is 365 days and a day is 24 hours.

Note that spaces are important.

Detailed rules

The resulting expression is made of components like 4 seconds, 1 year, etc. In general, a positive integer and one of the valid units of time, separated by a space. The unit of time is used in plural if the integer is greater than 1.

The components are separated by a comma and a space (", "). Except the last component, which is separated by " and ", just like it would be written in English.

A more significant units of time will occur before than a least significant one. Therefore, 1 second and 1 year is not correct, but 1 year and 1 second is.

Different components have different unit of times. So there is not repeated units like in 5 seconds and 1 second.

A component will not appear at all if its value happens to be zero. Hence, 1 minute and 0 seconds is not valid, but it should be just 1 minute.

A unit of time must be used "as much as possible". It means that the function should not return 61 seconds, but 1 minute and 1 second instead. Formally, the duration specified by of a component must not be greater than any valid more significant unit of time.
*/
func formatDuration(_ seconds: Int) -> String {
    
    if seconds == 0 {return "now"}
    
    let units:[(unit:String, seconds:Int)] = [("year",31536000), ("day",86400), ("hour",3600 ), ("minute",60),("second",1)]
    
    func createArrayOfUnits (_ seconds:Int, index:Int = 0, isFirstTime:Bool = true) -> String {
        if seconds == 0 {return ""}
        let (unit, secondsPerUnit) = units[index]
        let quantityForUnit = seconds/secondsPerUnit
        if quantityForUnit > 0 {
            let outputUnit = (quantityForUnit == 1) ? unit : unit + "s"
            let remainingSeconds = seconds  % secondsPerUnit
            if remainingSeconds == 0 {
                let prefix = (isFirstTime) ? "":" and "
                return "\(prefix)\(quantityForUnit) \(outputUnit)"
            } else {
                let prefix = (isFirstTime) ? "":", "
                return "\(prefix)\(quantityForUnit) \(outputUnit)" + createArrayOfUnits(remainingSeconds, index:index + 1, isFirstTime:false)
            }
        } else {
            return createArrayOfUnits(seconds, index:index + 1, isFirstTime:isFirstTime)
        }
    }
    
    return createArrayOfUnits(seconds)
}

import XCTest
class Tests: XCTestCase {
    let tests = [("testOneSecond", 1 ,"1 second"),
                 ("testTwoSecond", 2 ,"2 seconds"),
                 ("testOneMinute", 60 ,"1 minute"),
                 ("testTwoMinute", 120, "2 minutes"),
                 ("testSixtyOneSeconds", 61 , "1 minute and 1 second"),
                 ("testSixtyTwoSeconds", 62 , "1 minute and 2 seconds"),
                 ("testOneHour", 3600 ,"1 hour"),
                 ("testOneDay", 86400 ,"1 day"),
                 ("testOneYear", 31536000 ,"1 year"),
                 ("testOneHourOneMinuteOneSecond", 3661 ,"1 hour, 1 minute and 1 second"),
                 ("testOneDayOneHourOneMinuteOneSecond", 90061 , "1 day, 1 hour, 1 minute and 1 second" ),
                 ("testOneYearOneDayOneHourOneMinuteOneSecond", 31626061, "1 year, 1 day, 1 hour, 1 minute and 1 second"  ),
                 ("testTwoYearOneDayOneHourOneMinuteOneSecond", 63162061, "2 years, 1 day, 1 hour, 1 minute and 1 second"  )
    ]
    func testAll() {
        for (_, value, result) in tests {
            let formattedDuration = formatDuration(value)
            XCTAssertTrue(formattedDuration == result,"Value \(value) should return string '\(result)' but return '\(formattedDuration)'")
        }
    }
}
Tests.defaultTestSuite.run()



