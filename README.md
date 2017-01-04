# Ferrara

[![CI Status](http://img.shields.io/travis/muccy/Ferrara.svg?style=flat)](https://travis-ci.org/muccy/Ferrara)
[![Version](https://img.shields.io/cocoapods/v/Ferrara.svg?style=flat)](http://cocoadocs.org/docsets/Ferrara)
[![License](https://img.shields.io/cocoapods/l/Ferrara.svg?style=flat)](http://cocoadocs.org/docsets/Ferrara)
[![Platform](https://img.shields.io/cocoapods/p/Ferrara.svg?style=flat)](http://cocoadocs.org/docsets/Ferrara)

`Ferrara` is a framework which takes two collections and calculates differences between them. It returns you inserted indexes, deleted indexes, complete matches, partial matches and element movements.

## How

### `Matchable` protocol

You need your objects to conform protocol `Matchable`. This protocol is used to spot changes to objects.

```swift
struct Tulip: Matchable {
    let color: Color
    let thriving: Bool

    func match(with object: Tulip) -> Match {
        if color == object.color {
            if thriving == object.thriving {
                return .equal
            }
            else {
                return .change // Same color, but not thriving
            }
        }
        else {
            return .none
        }
    }
}
```

This is enough to calculate differences.

```swift
let oldTulips: [Tulip]
let newTulips: [Tulip]
let diff = Diff(from: oldTulips, to: newTulips)
```

### `Matchable` and `Equatable` together

If an object conforms to `Equatable`, a basic implementation of `match(with:)` is natural: if objects are equal, return `.equal`; otherwise return `.none`. You can take profit of this extension to perform simple diffs, without changes.

```swift
extension Int: Matchable {} // Use standard match(with:) implementation
let a: [Int]
let b: [Int]
let diff = Diff(from: a, to: b)
```

What is more you can use `Equatable` to simplify your custom objects.

```swift
struct Tulip: Matchable, Equatable {
    let color: Color
    let thriving: Bool
    
    static func ==(lhs: Tulip rhs: Tulip) -> Bool {
        return lhs.color == rhs.color && lhs.thriving == rhs.thriving
    }
    
    func match(with object: Tulip) -> Match {
        if self == object {
            return .equal
        }
        else if color == object.color {
            return .change
        }
        else {
            return .none
        }
    }
}
```

### `Identifiable` protocol

`Identifiable` protocol describes the common scenario when you need an object to be identifiable with a property. If you conform also to `Matchable` and `Equatable` you will have a free implementation of `match(with:)`.

```swift
struct Person: Identifiable, Matchable, Equatable {
    let identifier: String // This is enough for Identifiable conformance
    let name: String

    static func ==(lhs: Person rhs: Person) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name
    }
}

let lastYearPeople: [Person]
let thisYearPeople: [Person]
let diff = Diff(from: lastYearPeople, to: thisYearPeople)
```

## Requirements

* iOS 8.2 SDK.
* Minimum deployment target: iOS 8.

## Installation

`Ferrara` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Ferrara"
	
## Author

Marco Muccinelli, muccymac@gmail.com

## License

`Ferrara` is available under the MIT license. See the LICENSE file for more info.
