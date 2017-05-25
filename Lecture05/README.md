# CS193p 查漏补缺（三）Lecture 05

> Developing iOS 10 Apps with Swift - CS193p

| Date | Notes | Swift | Xcode |
|:-----:|:-----:|:-----:|:-----:|
| 2017-03-03 | 首次提交 | 3.0 | 8.2.1 |

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

**本文对应的 Demo 可以在：[https://github.com/kingcos/CS193P_2017/tree/master/Lecture05](https://github.com/kingcos/CS193P_2017/tree/master/Lecture05) 查看、下载。**

## Gestures

- 当 iOS 在运行时链接 `@IBOutlet` 后，属性观察器 `didSet` 即被调用。
- 当拖动手势产生，`target` 得到通知，调用相应 `action` 方法。

```Swift
// 在 Attributes Inspector 中勾选 User Interaction Enabled
@IBOutlet weak var panLabel: UILabel! {
    didSet {
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(ViewController.pan(recognizer:))
        )
        panLabel.addGestureRecognizer(panGestureRecognizer)
    }
}
```

### UIPanGestureRecognizer

```Swift
// 返回手势积累量
func translation(in view: UIView?) -> CGPoint
// 重置 translation，为防止多次手势叠加，需最后重置为 CGPoint.zero
func setTranslation(_ translation: CGPoint, in view: UIView?)
// 手势拖动速度，单位 points/s
func velocity(in view: UIView?) -> CGPoint
```

### UIGestureRecognizerState

- UIGestureRecognizerState 是手势状态的枚举。
- 手势开始前：`.possible`。
- 对于连续的手势：例如 pan（拖动），从 `.begin` 开始，重复 `.changed`，最后结束 `.ended`，状态有时会 `.failed` 或 `.cancelled`，需要特别注意。
- 对于不连续的手势：例如 swipe（猛划）、tap（轻拍），没有中间过程，直接 `.ended` 或 `.recognized`。

```Swift
func pan(recognizer: UIPanGestureRecognizer) {
    print("pan 手势状态枚举原始值：\(recognizer.state.rawValue)")

    switch recognizer.state {
    case .changed: fallthrough
    case .ended:
        let point = recognizer.translation(in: pannableLabel)
        let center = pannableLabel.center

        recognizer.view?.center = CGPoint(x: center.x + point.x, y: center.y)
        recognizer.setTranslation(CGPoint.zero, in: pannableLabel)
    default:
        break
    }
}

func tap(recognizer: UITapGestureRecognizer) {
    print("tap 手势状态枚举原始值：\(recognizer.state.rawValue)")
}
```

## MVC

- 本节主要涉及了多 MVC 的场景，例如 UINavigationController，UITabbarController，以及 UISplitController。
-  UISplitController 主要为大屏设备使用，为适配小屏，需配合 UINavigationController 使用。
- 本章内容使用文字表述过于复杂，未来可能整理至 Demo 中。

## Segue

- Segue 即转场。

### Types

- Show Segue: e.g. push
  - 从右向左进入，从左向右返回。
  - 嵌入 UINavigationController 时，头部自带返回按钮。
- Show Detail Segue: e.g. replace
  - 从下向上进入，从上向下返回。
  - 嵌入 UISplitViewController 时，替换 DetailViewController，不带返回按钮。
- Modally Segue
 - 由 Presentation 选项定义。
- Popover Segue
- Custom

### Identifier

- Segue 总是创建一个新的 MVC 实例（不会重用）。
- 使用代码调用 Segue `func performSegue(withIdentifier identifier: String, sender: Any?)`。

### Preparing

- 以下方法的调用时机在 Outlet 链接前。

```Swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
        switch identifier {
        case "Show Graph":
            if let vc = segue.destination as? GraphController {
                // Setup vc
            }
        default:
            break
        }
    }
}
```

### Preventing

- 若要 UIViewController 阻止 Segue 发生，重写以下方法并返回 `false` 即可。

```Swift
override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    return false
}
```

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
- [does anyone can explain the difference between segues: show, show detail, present modally, present as popover](http://stackoverflow.com/questions/26287247/does-anyone-can-explain-the-difference-between-segues-show-show-detail-presen)
