/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)

 ## Raw strings

 [SE-0200](https://github.com/apple/swift-evolution/blob/master/proposals/0200-raw-string-escaping.md) added the ability to create raw strings, where backslashes and quote marks are interpreted as those literal symbols rather than escapes characters or string terminators. This makes a number of use cases more easy, but regular expressions in particular will benefit.

 To use raw strings, place one or more `#` symbols before your strings, like this:
*/
    let rain = #"The "rain" in "Spain" falls mainly on the Spaniards."#
/*:
 The `#` symbols at the start and end of the string become part of the string delimiter, so Swift understands that the standalone quote marks around “rain” and “Spain” should be treated as literal quote marks rather than ending the string.

 Raw strings allow you to use backslashes too:
*/
    let keypaths = #"Swift keypaths such as \Person.name hold uninvoked references to properties."#
/*:
 That treats the backslash as being a literal character in the string, rather than an escape character. This in turn means that string interpolation works differently:
*/
    let answer = 42
    let dontpanic = #"The answer to life, the universe, and everything is \#(answer)."#
/*:
 Notice how I’ve used `\#(answer)` to use string interpolation – a regular `\(answer)` will be interpreted as characters in the string, so when you want string interpolation to happen in a raw string you must add the extra `#`.

 One of the interesting features of Swift’s raw strings is the use of hash symbols at the start and end, because you can use more than one in the unlikely event you’ll need to. It’s hard to provide a good example here because it really ought to be extremely rare, but consider this string: **My dog said "woof"#gooddog**. Because there’s no space before the hash, Swift will see `"#` and immediately interpret it as the string terminator. In this situation we need to change our delimiter from `#"` to `##"`, like this:
*/
    let str = ##"My dog said "woof"#gooddog"##
/*:
 Notice how the number of hashes at the end must match the number at the start.

 Raw strings are fully compatible with Swift’s multi-line string system – just use `#"""` to start, then `"""#` to end, like this:
*/
    let multiline = #"""
    The answer to life,
    the universe,
    and everything is \#(answer).
    """#
/*:
 Being able to do without lots of backslashes will prove particularly useful in regular expressions. For example, writing a simple regex to find keypaths such as `\Person.name` used to look like this:
*/
    let regex1 = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"
/*:
 Thanks to raw strings we can write the same thing with half the number of backslashes:
*/
    let regex2 = #"\\[A-Z]+[A-Za-z]+\.[a-z]+"#
/*:
 We still need *some*, because regular expressions use them too.
 
 &nbsp;

 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
