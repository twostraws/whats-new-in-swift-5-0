/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)

 ## Dynamically callable types

 [SE-0216](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md) adds a new `@dynamicCallable` attribute to Swift, which brings with it the ability to mark a type as being directly callable. It’s syntactic sugar rather than any sort of compiler magic, effectively `random(numberOfZeroes: 3)` into `random.dynamicallyCall(withKeywordArguments: ["numberOfZeroes": 3])`.

 `@dynamicCallable` is the natural extension of Swift 4.2's `@dynamicMemberLookup`, and serves the same purpose: to make it easier for Swift code to work alongside dynamic languages such as Python and JavaScript.

 To add this functionality to your own types, you need to add the `@dynamicCallable` attribute plus `func dynamicallyCall(withArguments args: [Int]) -> Double` and/or `func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double`.

 The first of those is used when you call the type without parameter labels (e.g. `a(b, c)`), and the second is used when you *do* provide labels (e.g. `a(b: cat, c: dog)`).

 `@dynamicCallable` is really flexible about which data types its methods accept and return, allowing you to benefit from all of Swift’s type safety while still having some wriggle room for advanced usage. So, for the first method (no parameter labels) you can use anything that conforms to `ExpressibleByArrayLiteral` such as arrays, array slices, and sets, and for the second method (with parameter labels) you can use anything that conforms to `ExpressibleByDictionaryLiteral` such as dictionaries and key value pairs.

 As well as accepting a variety of inputs, you can also provide multiple overloads for a variety of outputs – one might return a string, one an integer, and so on. As long as Swift is able to resolve which one is used, you can mix and match all you want.

 Let’s look at an example. Here’s a struct that generates numbers between 0 and a certain maximum, depending on what input was passed in:
*/
import Foundation

@dynamicCallable
struct RandomNumberGenerator1 {
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double {
        let numberOfZeroes = Double(args.first?.value ?? 0)
        let maximum = pow(10, numberOfZeroes)
        return Double.random(in: 0...maximum)
    }
}
/*:
 That method can be called with any number of parameters, or perhaps zero, so we read the first value carefully and use nil coalescing to make sure there’s a sensible default.

 We can now create an instance of `RandomNumberGenerator1` and call it like a function:
*/
let random1 = RandomNumberGenerator1()
let result1 = random1(numberOfZeroes: 0)
/*:
 If you had used `dynamicallyCall(withArguments:)` instead – or at the same time, because you can have them both a single type – then you’d write this:
*/
@dynamicCallable
struct RandomNumberGenerator2 {
    func dynamicallyCall(withArguments args: [Int]) -> Double {
        let numberOfZeroes = Double(args[0])
        let maximum = pow(10, numberOfZeroes)
        return Double.random(in: 0...maximum)
    }
}

let random2 = RandomNumberGenerator2()
let result2 = random2(0)
/*:
 There are some important rules to be aware of when using `@dynamicCallable`:

 - You can apply it to structs, enums, classes, and protocols.
 - If you implement `withKeywordArguments:` and don’t implement `withArguments:`, your type can still be called without parameter labels – you’ll just get empty strings for the keys.
 - If your implementations of `withKeywordArguments:` or `withArguments:` are marked as throwing, calling the type will also be throwing.
 - You can’t add `@dynamicCallable` to an extension, only the primary definition of a type.
 - You can still add other methods and properties to your type, and use them as normal.

 Perhaps more importantly, there is no support for method resolution, which means we must call the type directly (e.g. `random(numberOfZeroes: 5)`) rather than calling specific methods on the type (e.g. `random.generate(numberOfZeroes: 5)`). There is already some discussion on adding the latter using a method signature such as this: `func dynamicallyCallMethod(named: String, withKeywordArguments: KeyValuePairs<String, Int>)`.

 If that became possible in future Swift versions it might open up some very interesting possibilities for test mocking. In the meantime, `@dynamicCallable` is not likely to be widely popular, but it *is* hugely important for a small number of people who want interactivity with Python, JavaScript, and other languages.
 
 &nbsp;

 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
