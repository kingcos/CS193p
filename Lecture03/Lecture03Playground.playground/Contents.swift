//: Playground - noun: a place where people can play
//: Powered by http://maimieng.com from https://github.com/kingcos/CS193P_2017
//: See all at:

import UIKit

// Optional
enum Optional<T> {
    case none
    case some(T)
}

var label: UILabel! = UILabel()
label.text = "Optional Chain"

if let text = label?.text?.hashValue {
    print(text)
}

// Tuple
func getTemperature() -> (celsius: Double, fahrenheit: Double) {
    return (10.0, 50.0)
}

let currentTemperature = getTemperature()
print(currentTemperature.celsius)
print(currentTemperature.fahrenheit)

// Range
struct Range<T> {
    var startIndex: T
    var endIndex: T
}

for i in 0..<3 {
    print(i)
}

// Class & Structure & Enum
class ClassDemo : NSObject {
    var storedProperty = 0.0
    var computedProperty: Double {
        get {
            return 0.0
        }
        set {
            self.computedProperty = newValue
        }
    }
    
    init(prop: Double) {
        storedProperty = prop
    }
    
    func supportAllTheseThreeDataStructures() {
    }
}

struct StructDemo {
    var storedProperty = 0.0
    var computedProperty: Double {
        get {
            return 0.0
        }
        set {
            self.computedProperty = newValue
        }
    }
    
    init(prop: Double) {
        storedProperty = prop
    }
    
    func supportAllTheseThreeDataStructures() {
    }
}

enum EnumDemo {
    var computedProperty: Double {
        get {
            return 0.0
        }
        set {
            self.computedProperty = newValue
        }
    }
    
    func supportAllTheseThreeDataStructures() {
    }
}

// Type & Instance Methods/Properties
struct TypeDemo {
    static func testTypeMethod() {
        print(#function)
    }
    
    static var TypeProperty = 0.0
}

TypeDemo.testTypeMethod()
print(TypeDemo.TypeProperty)

// Array<T> Methods
let arrA = [1, 2, 3, 4, 5]
print(arrA.filter({ $0 > 3 }))

print(arrA.map({ Int($0) }))

print(arrA.reduce(0) { $0 + $1 })

// NSObject & NSNumber & Date & Data
let num = NSNumber(value: 3.14)
let numDoubleValue = num.doubleValue
let numBoolValue = num.boolValue
let numIntValue = num.intValue

let date = Date()
print(date)

let data = Data()

// UserDefaults 不适合 Playground 环境
let PI_ID = "PI"
let defaults = UserDefaults.standard
defaults.set(3.14, forKey: PI_ID)

if !defaults.synchronize() {
    print("Failed!")
}

defaults.set(nil, forKey: PI_ID)
defaults.double(forKey: PI_ID)

UIImage(named: "123")

// Assert
func validation() -> Int? {
    return nil
}

//assert(validation() != nil, "the validation function returned nil")
