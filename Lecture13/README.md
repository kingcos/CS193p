> Developing iOS 10 Apps with Swift - CS193p

| Date | Notes | Swift | Xcode |
|:-----:|:-----:|:-----:|:-----:|
| 2017-05-25 | 首次提交 | 3.1 | 8.3.2 |

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

**本文 Dynamic Animation 对应的 Demo 可以在：[https://github.com/kingcos/CS193P_2017/tree/master/Asteroids](https://github.com/kingcos/CS193P_2017/tree/master/Asteroids) 查看、下载。**

## Timer

- Timer，即定时器。
- Timer 的类方法：

```Swift
@available(iOS 10.0, *)
open class func scheduledTimer(withTimeInterval interval: TimeInterval,
repeats: Bool,
block: @escaping (Timer) -> Swift.Void) -> Timer
```

- Timer 的使用：

```Swift
// weak
private weak var timer: Timer?

// 开启 Timer（Run Loop 会保持强指针指向）
timer = Timer.scheduledTimer(withTimeInterval: 2.0,
                     repeats: true) { (timer) in
                        // do something...
}

// 停止 Timer（Run Loop 不再保持强指针指向，timer 将被设置为 nil）
timer.invalidate()

// 设置公差，单位秒（可能会提升系统性能）
timer.tolerance = 10
```

## Animation

- 动画分类：
  - UIView 动画
  - 控制器过渡
  - Core Animation
  - OpenGL & Metal
  - SpriteKit
  - Dynamic Animation

### UIView 动画

- UIView 可动画的属性：
  - frame/center
  - transform（变换，旋转，比例）
  - alpha（透明度）
  - backgroundColor
- UIView 动画的类方法：

```Swift
// 动画
@available(iOS 4.0, *)
open class func animate(withDuration duration: TimeInterval,
delay: TimeInterval,
options: UIViewAnimationOptions = [],
animations: @escaping () -> Swift.Void,
completion: ((Bool) -> Swift.Void)? = nil)

// 变换
@available(iOS 4.0, *)
open class func transition(with view: UIView, duration: TimeInterval,
options: UIViewAnimationOptions = [],
animations: (() -> Swift.Void)?,
completion: ((Bool) -> Swift.Void)? = nil)
```

- 方法中 animations 闭包内部的改变是立即生效的，尽管需要一段时间才显现。

### Dynamic Animation

- Dynamic Animation：物理特性相关的动画。

```Swift
// 创建 UIDynamicAnimator
var animator = UIDynamicAnimator(referenceView: UIView)

// 添加重力行为
let gravity = UIGravityBehavior()
animator.addBehavior(gravity)

// 添加碰撞行为
collider = UICollisionBehavior()
animator.addBehavior(collider)

// UIDynamicBehavior 添加 UIDynamicItem
let item1: UIDynamicItem = ... // usually a UIView
let item2: UIDynamicItem = ... // usually a UIView
gravity.addItem(item1)
collider.addItem(item1)
gravity.addItem(item2)
```

- UIDynamicItem 协议：任何动态项必须实现该协议（UIView 遵守该协议）。

```Swift
protocol UIDynamicItem {
    var bounds: CGRect { get } // bounds 不可动
    var center: CGPoint { get set } // 中心位置可变
    var transform: CGAffineTransform { get set } // 旋转也可
}
```

- 若在动画进行时调整中心或变形，必须调用 `func updateItemUsingCurrentState(item: UIDynamicItem)` 方法。
- Behaviors 行为：
  - UIGravityBehavior
  - UIAttachmentBehavior
  - UICollisionBehavior
  - UISnapBehavior
  - UIPushBehavior
  - UIDynamicItemBehavior

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
