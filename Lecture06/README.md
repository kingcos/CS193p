# CS193p 查漏补缺（四）Lecture 06

> Developing iOS 10 Apps with Swift - CS193p


- Info:
 - Swift 3.0
 - Xcode 8.2.1
 - macOS 10.12.4 beta (16E175b)

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

## Life Cycle

> 对象的生命周期一直是我们所需要关心的，老师在这一节也详细的讲述了 ViewController 的生命周期。为了搞清楚生命周期，特将该部分单独行文：[探究 UIViewController 生命周期](http://www.jianshu.com/p/9d3d95e1ef5a)。同时也更新了之前所写的[探究 UIView 生命周期（原题为：初探 iOS 中自定义 UIView 的初始化过程）](http://www.jianshu.com/p/bfea8efee664)。

## Memory Management

> 内存管理也是 iOS 中不可回避的问题，但由于我个人能力有限，这里只记录了老师所讲的点，未来可能会再进行总结。

- ARC: Automatic Reference Count 自动引用计数（!= Garbage Collection 垃圾回收）
- 引用类型（例如类）存储在堆（Heap）中。

### strong

- 「强」引用：
  - 默认的引用指针，可省略
  - 只要有强引用指针指向，对象将一直保存在堆中。

### weak

- 「弱」引用：
  - 当对象没有被使用时，即被销毁（nil）。
  - 弱引用用于指向引用类型的可选类型指针。
  - 弱引用指针将不会把对象保存在堆中。
- 例子：
  - outlets（其被视图层次强力持有，所以可为 weak）。

### unowned

- 「不」持有：
  - 需确保指针指向的对象没有被销毁（离开堆），否则程序会崩溃。
  - 常只用于打破循环引用。

### Closures

> 此处代码已更新至 [Calculator](https://github.com/kingcos/CS193P_2017/tree/master/Calculator)。

- 闭包是引用类型，同样存储在堆区。
- 闭包可以放在数组，字典等，是 Swift 的一等（first-class）类型。
- 当作为参数的闭包，执行的时机超出其自身时，需声明为逃逸闭包，即在闭包参数前加 `@escaping`：

```Swift
mutating func addUnaryOperation(named symbol: String, _ operation: @escaping (Double) -> Double) {
    operations[symbol] = Operation.unaryOperation(operation)
}
```

- 逃逸尾随闭包的使用：

```Swift
// 常规写法
brain.addUnaryOperation(named: "✅") { (value) -> Double in
    return sqrt(value)
}

// 简写
brain.addUnaryOperation(named: "✅") {
    return sqrt($0)
}
```

- 只要闭包仍保留在堆中，那么其捕获的引用也仍在堆中。
- 闭包中的循环引用：

```Swift
// 此时模型和控制器在闭包中相互引用，构成循环引用
brain.addUnaryOperation(named: "✅") {
    self.display.textColor = UIColor.green
    return sqrt($0)
}
```

- 解决闭包中的循环引用的方法：

1. weak

```Swift
brain.addUnaryOperation(named: "✅") { [weak self] in
    // self 为 Optional
    self?.display.textColor = UIColor.green
    return sqrt($0)
}

brain.addUnaryOperation(named: "✅") { [weak weakSelf = self] in
    weakSelf?.display.textColor = UIColor.green
    return sqrt($0)
}
```

2. unowned

```Swift
brain.addUnaryOperation(named: "✅") { [me = self] in
    me.display.textColor = UIColor.green
    return sqrt($0)
}

brain.addUnaryOperation(named: "✅") { [unowned me = self] in
    me.display.textColor = UIColor.green
    return sqrt($0)
}

brain.addUnaryOperation(named: "✅") { [unowned self = self] in
    self.display.textColor = UIColor.green
    return sqrt($0)
}

brain.addUnaryOperation(named: "✅") { [unowned self] in
    self.display.textColor = UIColor.green
    return sqrt($0)
}
```

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
- [探究 UIView 生命周期](http://www.jianshu.com/p/bfea8efee664)
- [探究 UIViewController 生命周期](http://www.jianshu.com/p/9d3d95e1ef5a)
