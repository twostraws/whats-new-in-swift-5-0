/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)

 ## Handling future enum cases

 [SE-0192](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md) adds the ability to distinguish between enums that are fixed and enums that might change in the future.

 One of Swift’s security features is that it requires all switch statements to be exhaustive – that they must cover all cases. While this works well from a safety perspective, it causes compatibility issues when new cases are added in the future: a system framework might send something different that you hadn’t catered for, or code you rely on might add a new case and cause your compile to break because your switch is no longer exhaustive.

 With the `@unknown` attribute we can now distinguish between two subtly different scenarios: “this default case should be run for all other cases because I don’t want to handle them individually,” and “I want to handle all cases individually, but if anything comes up in the future use this rather than causing an error.”

 Here’s an example enum:
*/
    enum PasswordError: Error {
        case short
        case obvious
        case simple
    }
/*:
 We could write code to handle each of those cases using a `switch` block:
*/
    func showOld(error: PasswordError) {
        switch error {
        case .short:
            print("Your password was too short.")
        case .obvious:
            print("Your password was too obvious.")
        default:
            print("Your password was too simple.")
        }
    }
/*:
 That uses two explicit cases for short and obvious passwords, but bundles the third case into a default block. 

 Now, if in the future we added a new case to the enum called `old`, for passwords that had been used previously, our `default` case would automatically be called even though its message doesn’t really make sense – the password might not be too simple.

 Swift can’t warn us about this code because it’s technically correct (the best kind of correct), so this mistake would easily be missed. Fortunately, the new `@unknown` attribute fixes it perfectly – it can be used only on the `default` case, and is designed to be run when new cases come along in the future.

 For example:
*/
    func showNew(error: PasswordError) {
        switch error {
        case .short:
            print("Your password was too short.")
        case .obvious:
            print("Your password was too obvious.")
        @unknown default:
            print("Your password wasn't suitable.")
        }
    }
/*:
 That code will now issue warnings because the `switch` block is no longer exhaustive – Swift wants us to handle each case explicitly. Helpfully this is only a *warning*, which is what makes this attribute so useful: if a framework adds a new case in the future you’ll be warned about it, but it won’t break your source code.
 
 &nbsp;

 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
