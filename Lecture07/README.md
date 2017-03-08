# CS193p 查漏补缺（五）Lecture 07

> Developing iOS 10 Apps with Swift - CS193p

- Info:
 - Swift 3.0
 - Xcode 8.2.1
 - macOS 10.12.4 beta (16E175b)

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

## Error

- 异常（Exception）不等于错误（Error）。

### throws

- 当一个方法有可能导致错误时，可以使用 throws 标志其可能抛出错误。

```Swift
enum SaveError: Error {
    case sizeTooBig
    case notFound
}

func save() throws -> String {
    // do sth...
    throw SaveError.notFound
}
```

### try

- 当调用一个 throws 的方法时，可以使用 do-catch 来捕获错误。

```Swift
func throwErr() throws {
    do {
        try save()
    } catch let error {
        throw error
    }
}
```

#### try?

- 当抛出错误时，返回 nil。

```Swift
// x: String?
let x = try? save()
```

#### try!

- 当抛出错误时，程序崩溃。
- 只在确定不会出现错误时使用。

```Swift
let y = try! save()
```
## Extension

- Extension，即扩展，类似于 Obj-C 的分类（Category）。
- 利用扩展，可以为类，结构体，枚举中添加方法和属性。
- 扩展中不能包含其本身已有的方法或属性。
- 只能扩展计算属性，不能扩展存储属性。
- 不可滥用扩展。

```Swift
extension UIViewController {
    var contentViewController: UIViewController! {
        // Extension 中的 self 指的是扩展的 UIViewController
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController
        } else {
            return self
        }
    }
}
```

## Protocols

- Protocol，即协议，类似其他语言的接口（interface），是一系列方法和属性的声明集合。
- 协议中不支持存储属性。
- 一个协议可以继承自多个协议。
- 一个协议实现者也可以继承自多个协议。

```swift
protocol InheritedProtocolA {
    func aMethod()
}

protocol InheritedProtocolB {
    func bMethod()
}

protocol SomeProtocol: InheritedProtocolA, InheritedProtocolB {
    // 协议中的属性只能是计算属性，且必须指定只读或可读可写
    var someProperty: Int { get set }
    func someMethod(arg1: Double, arg2: String) -> String
    // 希望方法修改自身，可以加上 mutating 关键字
    mutating func changeIt()
    init(arg: Int)
}

// class: 将规定只能由类实现该协议
protocol AProtocol: class {
    init(arg: Int)
}

// 协议中的初始化方法必须加上 required 关键字，否则其子类可能不会实现该方法
class ClassDemo: AProtocol {
    var propA: Int

    required internal init(arg: Int) {
        propA = arg
    }
}

protocol BProtocol {
    func printf()
    init(arg: Int)
}

// 扩展也可实现协议，常被用来作为协议的默认实现
extension ClassDemo: BProtocol {
    func printf() {
        print(#function)
    }
}
```

### Swift & Obj-C Protocol

- Swift 中的协议实现者必须实现协议中所有方法和属性。
- Obj-C 中的协议可以选择实现者是否必须实现。

```Swift
protocol SwiftProtocol {
    func thisMustBeImplemented()
}

@objc protocol ObjCProtocol {
    @objc optional func thisMaybeNotImplemented()
}
```

### A protocol as a type

- 一个协议是 Swift 中的一个类型。

```Swift
protocol Moveable {
    mutating func move(to point: CGPoint)
}

class Car: Moveable {
    internal func move(to point: CGPoint) {
        print("move to\(point)")
    }

    func changeOil() {
        print(#function)
    }
}

struct Shape: Moveable {
    mutating internal func move(to point: CGPoint) {
        print("move to\(point)")
    }

    func draw() {
        print(#function)
    }
}

let prius: Car = Car()
let square: Shape = Shape()


let thingsToMove: [Moveable] = [prius, square]

func slide(_ slider: Moveable) {
    var slider = slider
    let point = CGPoint.zero
    slider.move(to: point)
}

for thing in thingsToMove {
    slide(thing)
}
```

### Protocol with generics

- 协议可以用来限制范型。

```Swift
// Comparable 协议约束了 Range 中的范型必须实现该协议
struct Range<Bound: Comparable> {
    let lowerBound: Bound
    let upperBound: Bound
}
```
## Delegation

> 通过 [Cassini](https://github.com/kingcos/CS193P_2017/tree/master/Cassini) 可以很清楚的了解代理的基本使用。

- 视图声明代理协议；
- 视图拥有 weak delegate 属性；
- 视图利用 delegate 属性进行其自己不能掌控的事情；
- 控制器声明实现该协议；
- 控制器设置 self 为视图的 delegate 属性；
- 控制器实现协议中的方法和属性。

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
