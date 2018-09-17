/*:
 [< Previous](@previous)           [Home](Introduction)

 ## Transforming and unwrapping dictionary values with compactMapValues()

 [SE-0218](https://github.com/apple/swift-evolution/blob/master/proposals/0218-introduce-compact-map-values.md) adds a new `compactMapValues()` method to dictionaries, bringing together the `compactMap()` functionality from arrays (“transform my values, unwrap the results, then discard anything that’s nil”) with the `mapValues()` method from dictionaries (“leave my keys intact but transform my values”).

 As an example, here’s a dictionary of people in a race, along with the times they took to finish in seconds. One person did not finish, marked as “DNF”:
*/
    let times = [
        "Hudson": "38",
        "Clarke": "42",
        "Robinson": "35",
        "Hartis": "DNF"
    ]
/*:
We can use `compactMapValues()` to create a new dictionary with names and times as an integer, with the one DNF person removed:
*/
    let finishers1 = times.compactMapValues { Int($0) }
/*:
Alternatively, you could just pass the `Int` initializer directly to `compactMapValues()`, like this:
*/
    let finishers2 = times.compactMapValues(Int.init)
/*:
You can also use `compactMapValues()` to unwrap optionals and discard nil values without performing any sort of transformation, like this:
*/
    let people = [
        "Paul": 38,
        "Sophie": 8,
        "Charlotte": 5,
        "William": nil
    ]
    
    let knownAges = people.compactMapValues { $0 }
/*:
 [< Previous](@previous)           [Home](Introduction)
 */
