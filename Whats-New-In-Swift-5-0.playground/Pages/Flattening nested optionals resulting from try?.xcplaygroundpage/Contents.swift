/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)

 ## Flattening nested optionals resulting from try?

 [SE-0230](https://github.com/apple/swift-evolution/blob/master/proposals/0230-flatten-optional-try.md) modifies the way `try?` works so that nested optionals are flattened to become regular optionals. This makes it work the same way as optional chaining and conditional typecasts, both of which flatten optionals in earlier Swift versions.

 Here’s a practical example that demonstrates the change:
*/
struct User {
    var id: Int

    init?(id: Int) {
        if id < 1 {
            return nil
        }

        self.id = id
    }

    func getMessages() throws -> String {
        // complicated code here
        return "No messages"
    }
}

let user = User(id: 1)
let messages = try? user?.getMessages()
/*:
 The `User` struct has a failable initializer, because we want to make sure folks create users with a valid ID. The `getMessages()` method would in theory contain some sort of complicated code to get a list of all the messages for the user, so it’s marked as `throws`; I’ve made it return a fixed string so the code compiles.

 The key line is the last one: because the user is optional it uses optional chaining, and because `getMessages()` can throw it uses `try?` to convert the throwing method into an optional, so we end up with a nested optional. In Swift 4.2 and earlier this would make `messages` a `String??` – an optional optional string – but in Swift 5.0 and later `try?` won’t wrap values in an optional if they are already optional, so `messages` will just be a `String?`.

 This new behavior matches the existing behavior of optional chaining and conditional typecasting. That is, you could use optional chaining a dozen times in a single line of code if you wanted, but you wouldn’t end up with 12 nested optionals. Similarly, if you used optional chaining with `as?`, you would still end up with only one level of optionality, because that’s usually what you want.
 
 &nbsp;

 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
