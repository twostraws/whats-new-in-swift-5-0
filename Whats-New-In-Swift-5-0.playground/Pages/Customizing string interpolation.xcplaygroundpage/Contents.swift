/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)

 ## Customizing string interpolation

 [SE-0228](https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md) dramatically revamped Swift’s string interpolation system so that it’s more efficient and more flexible, and it’s creating a whole new range of features that were previously impossible.

 In its most basic form, the new string interpolation system lets us control how objects appear in strings. Swift has default behavior for structs that is helpful for debugging, because it prints the struct name followed by all its properties. But if you were working with classes (that don’t have this behavior), or wanted to format that output so it could be user-facing, then you could use the new string interpolation system.

 For example, if we had a struct like this:
*/
struct User {
    var name: String
    var age: Int
}
/*:
 If we wanted to add a special string interpolation for that so that we printed users neatly, we would add an extension to `String.StringInterpolation` with a new `appendInterpolation()` method. Swift already has several of these built in, and uses the interpolation *type* – in this case `User` to figure out which method to call.

 In this case, we’re going to add an implementation that puts the user’s name and age into a single string, then calls one of the built-in `appendInterpolation()` methods to add that to our string, like this:
*/
extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: User) {
        appendInterpolation("My name is \(value.name) and I'm \(value.age)")
    }
}
/*:
 Now we can create a user and print out their data:
*/
 let user = User(name: "Guybrush Threepwood", age: 33)
 print("User details: \(user)")
/*:
 That will print **User details: My name is Guybrush Threepwood and I'm 33**, whereas with the custom string interpolation it would have printed **User details: User(name: "Guybrush Threepwood", age: 33)**. Of course, that functionality is no different from just implementing the `CustomStringConvertible` protocol, so let’s move on to more advanced usages.

 Your custom interpolation method can take as many parameters as you need, labeled or unlabeled. For example, we could add an interpolation to print numbers using various styles, like this:
*/
import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(_ number: Int, style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = style

        if let result = formatter.string(from: number as NSNumber) {
            appendLiteral(result)
        }
    }
}
/*:
 The `NumberFormatter` class has a number of styles, including currency ($72.83), ordinal (1st, 12th), and spell out (five, forty-three). So, we could create a random number and have it spelled out into a string like this:
*/
 let number = Int.random(in: 0...100)
 let lucky = "The lucky number this week is \(number, style: .spellOut)."
 print(lucky)
/*:
 You can call `appendLiteral()` as many times as you need, or even not at all if necessary. For example, we could add a string interpolation to repeat a string multiple times, like this:
*/
extension String.StringInterpolation {
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0 ..< count {
            appendLiteral(str)
        }
    }
}

print("Baby shark \(repeat: "doo ", 6)")
/*:
 And, as these are just regular methods, you can use Swift’s full range of functionality. For example, we might add an interpolation that joins an array of strings together, but if that array is empty execute a closure that returns a string instead:
*/
extension String.StringInterpolation {
    mutating func appendInterpolation(_ values: [String], empty defaultValue: @autoclosure () -> String) {
        if values.count == 0 {
            appendLiteral(defaultValue())
        } else {
            appendLiteral(values.joined(separator: ", "))
        }
    }
}

let names = ["Harry", "Ron", "Hermione"]
print("List of students: \(names, empty: "No one").")
/*:
 Using `@autoclosure` means that we can use simple values or call complex functions for the default value, but none of that work will be done unless `values.count` is zero.

 With a combination of the `ExpressibleByStringLiteral` and `ExpressibleByStringInterpolation` protocols it’s now possible to create whole types using string interpolation, and if we add `CustomStringConvertible` we can even make those types print as strings however we want.

 To make this work, we need to fulfill some specific criteria:

 - Whatever type we create should conform to `ExpressibleByStringLiteral`, `ExpressibleByStringInterpolation`, and `CustomStringConvertible`. The latter is only needed if you want to customize the way the type is printed.
 - *Inside* your type needs to be a nested struct called `StringInterpolation` that conforms to `StringInterpolationProtocol`.
 - The nested struct needs to have an initializer that accepts two integers telling us roughly how much data it can expect.
 - It also needs to implement an `appendLiteral()` method, as well as one or more `appendInterpolation()` methods.
 - Your main type needs to have two initializers that allow it to be created from string literals and string interpolations.

 We can put all that together into an example type that can construct HTML from various common elements. The “scratchpad” inside the nested `StringInterpolation` struct will be a string: each time a new literal or interpolation is added, we’ll append it to the string. To help you see exactly what’s going on, I’ve added some `print()` calls inside the various append methods.

 Here’s the code.
*/
struct HTMLComponent: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
    struct StringInterpolation: StringInterpolationProtocol {
        // start with an empty string
        var output = ""

        // allocate enough space to hold twice the amount of literal text
        init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity * 2)
        }

        // a hard-coded piece of text – just add it
        mutating func appendLiteral(_ literal: String) {
            print("Appending \(literal)")
            output.append(literal)
        }

        // a Twitter username – add it as a link
        mutating func appendInterpolation(twitter: String) {
            print("Appending \(twitter)")
            output.append("<a href=\"https://twitter/\(twitter)\">@\(twitter)</a>")
        }

        // an email address – add it using mailto
        mutating func appendInterpolation(email: String) {
            print("Appending \(email)")
            output.append("<a href=\"mailto:\(email)\">\(email)</a>")
        }
    }

    // the finished text for this whole component
    let description: String

    // create an instance from a literal string
    init(stringLiteral value: String) {
        description = value
    }

    // create an instance from an interpolated string
    init(stringInterpolation: StringInterpolation) {
        description = stringInterpolation.output
    }
}
/*:
 We can now create and use an instance of `HTMLComponent` using string interpolation like this:
*/
 let text: HTMLComponent = "You should follow me on Twitter \(twitter: "twostraws"), or you can email me at \(email: "paul@hackingwithswift.com")."
 print(text)
/*:
 Thanks to the `print()` calls that were scattered inside, you’ll see exactly how the string interpolation functionality works: you’ll see “Appending You should follow me on Twitter”, “Appending twostraws”, “Appending , or you can email me at “, “Appending paul@hackingwithswift.com”, and finally “Appending .” – each part triggers a method call, and is added to our string.

 &nbsp;

 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
