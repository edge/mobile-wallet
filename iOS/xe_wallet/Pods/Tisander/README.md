# Tisander

[![Build Status](https://travis-ci.org/mikezs/Tisander.svg?branch=master)](https://travis-ci.org/mikezs/Tisander)
[![Code Coverage](https://img.shields.io/codecov/c/github/mikezs/Tisander.svg)](https://codecov.io/gh/mikezs/Tisander)
[![Documentation](https://mikezs.github.io/Tisander/badge.svg)](https://mikezs.github.io/Tisander)
[![CocoaPods](https://img.shields.io/cocoapods/dt/Tisander.svg)](https://cocoapods.org/pods/Tisander)
[![Swift](https://img.shields.io/badge/Swift-4.1-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-9.4-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

## Ordered JSON parser in pure Swift

I needed a JSON parser that has all of the items in dictionaries to be sorted to work around an issue where an existing API couldn't be changed to return objects in an array. In my quest to find this, I noticed almost all parsers used `JSONSerialization` from Apple to create their dictionaries and the dictionaries (quite correctly) has no order, but it was not consistent. Different platforms (simulator vs device) would give different orders and this is not something I could accept in my work.

The parser is now pure Swift and returns an array of either `JSON.ArrayValues` or `JSON.ObjectValues` (depending on what the structure was when they were parsed). This can be accessed by subscripting a `String` or `Int` and then cast to get values. Most importantly for me, you can get .allKeys from the array of `JSON.ObjectValues` and they are sorted in the order they were in the JSON file because JSONSwift is: A JSON parser written from the ground up in pure Swift. It is a functional recursive descent parser.

## Installing

### Cocoapods

Add this to your Podfile

```
pod 'Tisander', '~> 1.0'
```

### Manual

Copy `JSON.swift` file into your project. Or just import the framework. That's it. :)

## How to use:

### Parse JSON Object

```swift
// Data
let jsonString = """
{
    "Monday": [
        {
            "title": "Test Driven Development",
            "speaker": "Jason Shapiro",
            "time": "9:00 AM"
        },
        {
            "title": "Java Tools",
            "speaker": "Jim White",
            "time": "9:00 AM"
        }
    ],
    "Tuesday": [
        {
            "title": "MongoDB",
            "speaker": "Davin Mickleson",
            "time": "1:00 PM"
        },
        {
            "title": "Debugging with Xcode",
            "speaker": "Jason Shapiro",
            "time": "1:00 PM",
        }
    ]
}
"""
```

Call the static method `JSON.parse(string:)` with the jsonString string, and use optional chaining to get the values you want:

```swift
JSON.parse(string: jsonString)?["Monday"]?.values?.forEach({ (day) in
    print(day["title"])
})

// Prints:
//  Test Driven Development
//  Java Tools
```

## Authors

#### Tisander author:

[Mike Bignell](https://github.com/mikezs)

#### JSONSwift authors:

[Ankit Goel](https://github.com/ankit1ank)

[Kartik Yelchuru](https://github.com/buildAI)
