/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)

 ## Counting matching items in a sequence

 [SE-0220](https://github.com/apple/swift-evolution/blob/master/proposals/0220-count-where.md) introduces a new `count(where:)` method that performs the equivalent of a `filter()` and count in a single pass. This saves the creation of a new array that gets immediately discarded, and provides a clear and concise solution to a common problem.

 This example creates an array of test results, and counts how many are greater or equal to 85:
*/
    let scores = [100, 80, 85]
    let passCount = scores.count { $0 >= 85 }
/*:
 And this counts how many names in an array start with “Terry”:
*/
    let pythons = ["Eric Idle", "Graham Chapman", "John Cleese", "Michael Palin", "Terry Gilliam", "Terry Jones"]
    let terryCount = pythons.count { $0.hasPrefix("Terry") }
/*:
 This method is available to all types that conform to `Sequence`, so you can use it on sets and dictionaries too.
 
 &nbsp;

 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
