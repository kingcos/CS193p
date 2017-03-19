# CS193p 查漏补缺（六）Lecture 08

> Developing iOS 10 Apps with Swift - CS193p

- Info:
 - Swift 3.0
 - Xcode 8.3 beta
 - macOS 10.12.4 beta (16E175b)

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

**本文对应的 Demo 可以在：[https://github.com/kingcos/CS193P_2017/tree/master/Lecture08](https://github.com/kingcos/CS193P_2017/tree/master/Lecture08) 查看、下载。模拟器中打开软键盘：Simulator-Hardware-Keyboard-Toggle Software Keyboard**

## Multithreading

> 由于多线程部分是 iOS 中的一个难点、重点，因此正在总结一篇更加全面、且适用于 Swift 3.0 的文章，之后会在此更新相应链接。

## UITextField

- UITextField 是 iOS 中的文本输入控件，部分属性类似于 UILabel。
- 当用户点击 UITextField 或发送 `becomeFirstResponder` 消息，即成为第一响应者（First Responder），软键盘随即显示；发送 `resignFirstResponder` 消息，则注销第一响应者，键盘随即消失。
- 控制器若要代理 UITextField，需遵从 UITextFieldDelegate 协议，并通过 Storyboard 或代码设置代理，即可实现相应代理方法。
- UITextField 也实现了 UIControl 协议，即遵守了 [Target-Action 设计模式](http://www.jianshu.com/p/b00056fac0a8)。

### Keyboard

- 软键盘的属性定义在 UITextInputTraits 协议中，UITextField 实现了该协议，因此可以通过 UITextField 更改软件的属性。
- 软键盘上方可以自定义视图，设置为 UITextField 的 `inputAccessoryView` 属性即可。
- 软键盘弹出时，会覆盖在其他控件之上，为了良好的用户体验，UITextField 要保持可见（不能被覆盖）。
- UITableViewController 会监听 UITextField，并当键盘弹出时，自动调整到该 UITextField 的一行，即 UITextField 不会被覆盖。
- 可以通过 UIWindow 发出的 Notification（通知）来响应，当相应的事件发生时，注册的方法将会被调用。如下：`Notification.Name.UIKeyboardDidShow` 事件发生，selector 的方法即被调用。

```Swift
// 通知
NotificationCenter.default.addObserver(self,
                                       selector: #selector(keyboardAppeared(_:)),
                                       name: Notification.Name.UIKeyboardDidShow,
                                       object: view.window)

func keyboardAppeared(_ notification: Notification) {
        // Do something...
        print("\(#function) - \(notification.userInfo ?? [:])")
}
```

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
- [小窥 iOS 中的 Target-Action 设计模式](http://www.jianshu.com/p/b00056fac0a8)
