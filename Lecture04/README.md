# CS193p 查漏补缺（二）Lecture 04

> Developing iOS 10 Apps with Swift - CS193p

- Info:
 - Swift 3.0
 - Xcode 8.2.1
 - macOS 10.12.4 beta (16E154a)

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

**本文对应的 Demo 可以在：[https://github.com/kingcos/CS193P_2017/Lecture04](https://github.com/kingcos/CS193P_2017/Lecture04) 查看、下载。**

## UIWindow

> 该节部分参考《iOS 开发进阶——唐巧》。

### 简介

`class UIWindow : UIView`

UIWindow 是位于视图等级最顶层的 UIView（甚至包含状态栏）。通常一个 iOS 应用只有一个 UIWindow。

UIWindow 在纯代码 AppDelegate.swift 的使用：

```Swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    // 1. 创建窗口
    window = UIWindow(frame: UIScreen.main.bounds)
    // 2. 创建窗口根控制器
    let rootViewController = UIViewController()
    window?.rootViewController = rootViewController
    // 3. 显示窗口
    window?.makeKeyAndVisible()

    return true
}
```

UIWindow 的主要作用：

1. 包含应用所需的所有 UIView 视图（控件）
2. 传递触摸消息和键盘事件到 UIView

为 UIWindow 增加 UIView 视图的方法：

1. 利用父类 UIView 的 `open func addSubview(_ view: UIView)`
2. 设置要添加视图对应的 UIViewController 为其特有的 `rootViewController`，将自动把其视图添加到当前窗口，同时负责维护控制器和视图的生命周期

UIWindowLevel 即 UIWindow 层级。默认 UIWindow 的层级为 UIWindowLevelNormal。利用 UIWindow 会自动覆盖到所有界面最顶层的特性，可以为 App 加入密码保护（手势解锁）的功能。当 UIWindow 需要处理键盘事件，需要 `makeKey()` 设置为 Key Window。但是 UIWindow 也不应当滥用。

该处的 Swift 版 Demo 详见 []()。

## Initializing a UIView

详见[初探 iOS 中自定义 UIView 的初始化过程](http://www.jianshu.com/p/bfea8efee664)一文，现已加入对 CS193p 的更新。

## Points & Pixels

- 像素（Pixel）是绘制设备屏幕的最小单位。
- 点（Point）是坐标系的单位。
- 在 iOS 中，通常 1 个点为 2 个像素（2x），iPhone Plus 的屏幕为 3x。
- `contentScaleFactor`：应用于视图的比例（Pixels Per Point）

## Bounds & Frame

详见[iOS 中的 bounds & frame](http://www.jianshu.com/p/edb2ae03115c)一文，现已加入对 CS193p 的更新。

## Custom UIView

- 创建自定义 UIView，需要绘制视图时可重写 `draw(_ rect: CGRect)` 方法。除非必要不要重写该方法，将影响性能。
- 不可直接调用 `draw(_ rect: CGRect)` 方法，当需要重新绘制时，我们可以调用 `setNeedsDisplay()` 或 `setNeedsDisplay(_ rect: CGRect)`，系统将适时调用 `draw(_ rect: CGRect)`。

## Core Graphics

- CG 即 Core Graphics。
- 获取需要绘制的上下文（context），UIGraphicsGetCurrentContext 即可在 `draw(_ rect: CGRect)` 方法中使用 -> 创建路径（path）-> 设置绘制属性（字体，颜色等）-> 使用以上属性在路径中填充（stroke/fill）。

## UIBezierPath

### 自定路径

- 实例化 -> UIBezierPath 将自动在当前上下文绘制（`draw(_ rect: CGRect)` 将该步完成）-> UIBezierPath 设置绘制和属性 -> 使用 UIColor 设置画笔和填充颜色 -> UIBezierPath 绘制和填充

```Swift
//实例化
let path = UIBezierPath()

// UIBezierPath 设置绘制和属性
path.lineWidth = 3.0

path.move(to: CGPoint(x: 80, y: 50))
path.addLine(to: CGPoint(x: 140, y: 150))
path.addLine(to: CGPoint(x: 10, y: 150))

// 关闭路径
path.close()

// 使用 UIColor 设置画笔和填充颜色
UIColor.green.setFill()
UIColor.red.setStroke()

// UIBezierPath 绘制和填充
path.fill()
path.stroke()
```

### 内置路径

- 利用 UIBezierPath 不同的构造器可以绘制内置的路径，例如圆角矩形，椭圆等。
- `addClip()`：剪裁
- `contains(_ point: CGPoint)`：判断 CGPoint 是否在路径内（路径必需闭合）

## UIColor

- Alpha 透明度：`UIColor.red.withAlphaComponent(0.5)`（范围 0.0 - 1.0）。

## View Transparency

- `isOpaque` 默认为 `true`，即不透明。视图若要透明，需要先设置 `isOpaque = false`。当 `isOpaque` 为 `true`，视图整体或部分为透明，将出现不可预料的结果（参考苹果官方文档）。
- 设置整个视图的透明度：`alpha = 0.1`（注意设置 `isOpaque = false`）
- 不移除视图但完全隐藏视图：`isHidden = true`（不绘制且不响应事件）

## NSAttributedString

- NSAttributedString 不是 String，也不是 NSString。
- 可变 NSAttributedString 为：NSMutableAttributedString。
- 在 `draw(_ rect: CGRect)` 中绘制文字时，需要使用 NSAttributedString。

```Swift
let text = NSAttributedString(string: "maimieng.com")
text.draw(at: CGPoint(x: 50.0, y: 50.0))

let swiftStr: String = text.string
```

- 为 NSMutableAttributedString 设置多个属性：

```Swift
let params = [NSForegroundColorAttributeName : UIColor.red,
              NSStrokeWidthAttributeName : 5.0,
              NSFontAttributeName : UIFont.boldSystemFont(ofSize: 20.0)] as [String : Any]
let attStr = NSMutableAttributedString(string: "0123456789")
// 12345 的相应属性将被设置；这里为 NSRange
attStr.setAttributes(params, range: NSMakeRange(1, 5))
attStr.draw(at: CGPoint(x: 50.0, y: 50.0))
```

- UTF16View 代表字符串作为一串 16 位的 Unicode 字符集，其索引类型仍为 `String.Index`。

```swift
let myBlog = "maimieng.com"
let strUTF16View = myBlog.utf16
```

## UIFont

- `UIFont.preferredFont(forTextStyle: .body)`：根据给定的文本风格获得相应的字体。

## UIImage

- 有关 Core Graphics 绘制 UIImage 可参考 `UIGraphicsBeginImageContext(_ size: CGSize)`。
- 绘制 UIImage：

```swift
let image = UIImage()

// 原点（左上角）为 CGPoint 绘制
image.draw(at: CGPoint)
// 缩放图片到适合 CGRect 绘制
image.draw(in: CGRect)
// 平铺图片到 CGRect 内绘制
image.drawAsPattern(in: CGRect)
```

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
- [初探 iOS 中自定义 UIView 的初始化过程](http://www.jianshu.com/p/bfea8efee664)
- [iOS 中的 bounds & frame](http://www.jianshu.com/p/edb2ae03115c)
- [tangqiaoboy/iOS-Pro](https://github.com/tangqiaoboy/iOS-Pro)
- [isOpaque - Apple Inc.](https://developer.apple.com/reference/uikit/uiview/1622622-isopaque)
