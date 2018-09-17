/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)

 ## Checking for integer multiples

 [SE-0225](https://github.com/apple/swift-evolution/blob/master/proposals/0225-binaryinteger-iseven-isodd-ismultiple.md) adds an `isMultiple(of:)` method to integers, allowing us to check whether one number is a multiple of another in a much clearer way than using the division remainder operation, `%`.

 For example:
*/
    let rowNumber = 4
    
    if rowNumber.isMultiple(of: 2) {
        print("Even")
    } else {
        print("Odd")
    }
/*:
 Yes, we could write the same check using `if rowNumber % 2 == 0` but you have to admit that’s less clear – having `isMultiple(of:)` as a method means it can be listed in code completion options in Xcode, which aids discoverability.
 
 &nbsp;

 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
