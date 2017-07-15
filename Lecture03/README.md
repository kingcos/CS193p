# CS193p 查漏补缺（一）Lecture 03

> Developing iOS 10 Apps with Swift - CS193p

|    Date    | Notes | Swift | Xcode |
| :--------: | :---: | :---: | :---: |
| 2017-02-21 | 首次提交  |  3.0  | 8.2.1 |

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

**本文对应的 Playground 可以在：[https://github.com/kingcos/CS193P_2017/Lecture03](https://github.com/kingcos/CS193P_2017/Lecture03) 查看、下载。**

## Optional

- 可选类型的本质是枚举（enum）。

```swift
enum Optional<T> {
    case none
    case some(T)
}
```

- 可选类型可以链式使用。

```swift
var label: UILabel! = UILabel()
label.text = "Optional Chain"

if let text = label?.text?.hashValue {
    print(text)
}
```

- 可选类型的”默认值“操作符。
```swift
let defaultColorName = "red"
var userDefinedColorName: String?   // defaults to nil
var colorNameToUse = userDefinedColorName ?? defaultColorName
```

## Tuple

- 元组作为函数返回值。

```swift
func getTemperature() -> (celsius: Double, fahrenheit: Double) {
    return (10.0, 50.0)
}

let currentTemperature = getTemperature()
print(currentTemperature.celsius)
print(currentTemperature.fahrenheit)
```

## Range

- Range 是范型的，但只支持可比较（Comparable）的类型。

```swift
struct Range<T> {
    var startIndex: T
    var endIndex: T
}
```

- CountableRange 是一段连续值，因此可以使用 `for-in` 遍历。

```swift
for i in 0..<3 {
    print(i)
}

// 步长非 1 的遍历可以使用全局的 stride 方法
```

## Class & Structure & Enum

> 该部分内容可能未来会单独总结，这里仅总结该课程的内容

### 相同点

- 相同的声明语法：

```swift
class ClassDemo {
}

struct StructDemo {
}

enum EnumDemo {
}
```

- 属性和方法：

> 注：Swift 中的 Properties 即 Instance Variable 实例变量，方法即 `func`。

```swift
// 方法
func supportAllTheseThreeDataStructures() {
}

// 注：枚举不支持存储属性
var storedProperty = 0.0

var computedProperty: Double {
   get {
       return 0.0
   }
   set {
       self.computedProperty = newValue
   }
}
```

- 构造器：

```swift
// 枚举不支持构造器；结构体有默认的构造器
init(prop: Double) {
    storedProperty = prop
}
```

### 不同点

- 继承：

```swift
// 只有类支持继承
class ClassDemo : NSObject {
}
```

- 值类型和引用类型：

这三个数据结构中，类是引用类型，结构体和枚举是值类型。详细的比较可以参考我之前所写的 [Swift 中的值类型与引用类型](http://www.jianshu.com/p/ba12b64f6350)一文。

## Type & Instance Methods/Properties

- 类型方法和属性是直接由类名调用的，需要在方法或属性前加上 `static` 关键字。关于属性的知识可以参考我之前所写的[浅谈 Swift 中的属性（Property）](http://www.jianshu.com/p/fe60f5bafab3)一文。

```swift
struct TypeDemo {
    static func testTypeMethod() {
        print(#function)
    }

    static var TypeProperty = 0.0
}

TypeDemo.testTypeMethod()
print(TypeDemo.TypeProperty)
```

## Array<T> Methods

> 可能是在讲这一段的时候，老师提到了 Functional Programming 就十分兴奋，说了很多鼓励学生学习的话。我虽然知道函数式编程的基本概念，但尚未学习。希望未来可以在这里与大家分享学习函数式编程的内容。

### filter

`public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element]`

- filter 返回一个新的数组，其中的元素为满足过滤器内部规则的元素。

```swift
let arrA = [1, 2, 3, 4, 5]
// 将大于 3 的元素过滤出，放入新的数组
print(arrA.filter({ $0 > 3 }))
```

### map

`public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]`

- map 返回一个新的数组，其中的元素为原数组每个元素变换得来的元素。

```swift
let arrA = [1, 2, 3, 4, 5]
// 将每个元素转换为 Int，放入新的数组
print(arrA.map({ Int($0) }))
```

### reduce

`public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result`

- reduce 将整个数组返回为一个值。

```swift
let arrA = [1, 2, 3, 4, 5]
// 将每个元素累加，初始值为 0
print(arrA.reduce(0) { $0 + $1 })
```

## String.Index

> 字符串的索引并不是类似其他语言中的整型，由于内容和 [Swift 中的字符串截取](http://www.jianshu.com/p/94310202ba1b)略有重复，所以不再重复说明。

## NSObject & NSNumber & Date & Data

- 这里的几个类型老师也在其 Lecture 中提到，这里仅作了解。

### NSObject

- NSObject 是所有 Objective-C 类的基类。现阶段，在 Swift 中有时为了一些特性还是会继承自该类。

### NSNumber

- NSNumber 是通用的保存数字的类（引用类型）。

```Swift
let num = NSNumber(value: 3.14)
let numDoubleValue = num.doubleValue
let numBoolValue = num.boolValue
let numIntValue = num.intValue
```

### Date

- Date 是值类型，可以通过 Date 获取当前日期时间，以及未来或过去的日期时间。同理的还有 Calendar，DateFormatter，DateComponents。
- 如果 App 需要本地化时间时，可能会用到该类。

```swift
let date = Date()
print(date)
```

### Data

- Data 是值类型，可以通过 iOS SDK 用来保存，恢复，交换原始数据。

```swift
let data = Data()
```

## Initializers

### 指定构造函数 & 便利构造函数

- 指定构造函数
  - 指定构造函数仅且必须调用其父类的便利构造函数
  - 在调用父类指定构造函数之前，本类引入的属性必须已经被初始化
  - 在调用父类指定构造函数之后，本类继承的属性才能被初始化

```swift
class ClassA {
    var propCA1: Int
    var propCA2: Int

    init(propCA1: Int, propCA2: Int) {
        self.propCA1 = propCA1
        self.propCA2 = propCA2
    }
}

class ClassB : ClassA {
    var propCB: Int

    init(propCA1: Int, propCA2: Int, propCB: Int) {
        self.propCB = propCB
        super.init(propCA1: propCA1, propCA2: propCA2)
        self.propCA2 = propCA2
    }
}
```

- 便利构造函数
  - 便利构造函数仅且必须调用一个其自身的 init
  - 便利构造函数必须在设值前调用该 init

```swift
class ClassB : ClassA {
    var propCB: Int

    init(propCA1: Int, propCA2: Int, propCB: Int) {
        self.propCB = propCB
        super.init(propCA1: propCA1, propCA2: propCA2)
        self.propCA2 = propCA2
    }

    convenience init(x: Int, y: Int) {
        let z = x + y
        self.init(propCA1: z, propCA2: 1, propCB: 1)
    }
}
```

### 继承构造函数 & 必需构造函数

- 如果子类没有实现任何指定构造函数，那么该子类继承父类所有的指定构造函数。
- 如果子类重写父类所有的指定构造函数，那么该子类继承父类所有的便利构造函数。
- 如果子类没有实现构造函数，那么该子类将继承父类所有的构造函数。
- 必需构造函数需要在 `init` 前加上 `required`，其子类必须重写该构造方法。

### 可失败构造函数

- `init?()` 被称作可失败构造函数，其返回一个可选类型。例如 UIImage 的 `init?(named name: String)` 就是一个可失败构造函数。因为传入的 `name` 并不一定对应项目中的一张图片，所以当图片不存在即返回 nil。

## Any & AnyObject

- Any & AnyObject 主要是为了兼容旧的 Objective-C 的 API。Any 可以保存任何类型，而 AnyObject 只能保存类。由于 Swift 是强类型语言，Any & AnyObject 必须转换为具体的类型才能调用其中的方法或属性。当我们不需要调用者知道返回值的类型时，可以使用 Any。

## UserDefaults

- UserDefaults 是一个轻量级的微数据库，适合存储设置等，而不能存储较大的数据。UserDefaults 只能存储 Property List 数据，Property List 是 Array，Dictionary，String，Date，Data，Int 等的结合体，这是一个 Objective-C 的 API，使用 Any 类型。

```swift
let PI_ID = "PI"
let defaults = UserDefaults.standard
defaults.set(3.14, forKey: PI_ID)

if !defaults.synchronize() {
    print("Failed!")
}

defaults.set(nil, forKey: PI_ID)
defaults.double(forKey: PI_ID)
```

## Assert

- Assert 即断言，是 Debug 的一种方法。可以在一些条件不为 `true` 时，崩溃程序并打印指定信息，来使得我们注意到。当我们构建 release 版本时，断言将被完全忽略。

```swift
// 当 validation() 返回 nil 时，断言触发，程序 crash 并打印 the validation function returned nil；当返回非 nil 时，则无影响
assert(validation() != nil, "the validation function returned nil")
```

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
- [Swift 中的值类型与引用类型](http://www.jianshu.com/p/ba12b64f6350)
- [浅谈 Swift 中的属性（Property）](http://www.jianshu.com/p/fe60f5bafab3)
- [Swift 中的字符串截取](http://www.jianshu.com/p/94310202ba1b)
