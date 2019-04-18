/*:
 [< Anterior](@previous)           [Home](Introduction)           [Próximo >](@next)

 ## Raw strings
 [SE-0200](https://github.com/apple/swift-evolution/blob/master/proposals/0200-raw-string-escaping.md) adicionado habilidade de criar raw strings, onde barras invertidas e marcas de citação são interpretadas como simbolos literais ao inves de caracteres de escape. Isso faz com que o numero de caso de uso seja mais facil, portanto expressoes regulares irão se beneficiar.

 Para usar raw strings, coloque um ou mais `#` antes da sua string, como abaixo:
*/
    let rain = #"A "chuva" na "Espanha" cai principalmente sobre os Espanhóis"#
/*:
 Os `#` do inicio e ao final tornam-se parte de delimitadores da string, então o Swift entende que as marcas de citação independentes em torno de “chuva” e “Espanha” deveriam ser tratadas como marcas de citações literais be treated em vez de terminar a string.

 Raw strings deixa você usar barras invertidas também:
*/
    let keypaths = #"Swift keypaths como \Person.name mantem referencia de propriedades."#
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

 [< Anterior](@previous)           [Home](Introduction)           [Próximo >](@next)
 */
