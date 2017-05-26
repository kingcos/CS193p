> Developing iOS 10 Apps with Swift - CS193p

| Date | Notes | Swift | Xcode |
|:-----:|:-----:|:-----:|:-----:|
| 2017-05-26 | 首次提交 | 3.1 | 8.3.2 |

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

## Alerts & Action Sheets

- Alerts & Action Sheets 即提醒和动作菜单，在开发中十分常用。

```Swift
let alert = UIAlertController(title: "Invalid Face",
                              message: "A face must have a name",
                              preferredStyle: .alert)
alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
    self.nameTextField.text = alert.textFields?.first?.text
    self.performSegue(withIdentifier: "Add Emotion", sender: nil)
}))
alert.addTextField(configurationHandler: nil)

present(alert, animated: true)
```

## Notification

- Notification 即通知，使得模型和控制器通信。

```Swift
// 默认通知中心
var center = NotificationCenter.default
// 观察者
var observer = center.addObserver(forName: NSNotification.Name.UIContentSizeCategoryDidChange,
                                                  object: UIApplication.shared,
                                                  queue: OperationQueue.main) { (notification) in
                                                    let c = notification.userInfo?[UIContentSizeCategory]
}

// 发送通知
center.post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable : Any]?)
```

## App Lifecycle

![App 的状态 by CS193p](http://upload-images.jianshu.io/upload_images/227002-488f0a5b3d4dd9cc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- App 的状态：
  - 未运行（Not running）
  - 前台：
    - 未激活（Inactive）：运行，但不响应 UI 事件
    - 已激活（Active）：接收和处理 UI 事件
  - 后台（Background）：有限时间内运行，不响应 UI 事件
  - 暂停（Suspended）：未运行，可能被杀掉
- AppDelegate 将会收到相应通知，其遵守了 UIApplicationDelegate 代理。

## UIApplication

> 该部分内容已更新至[浅谈 iOS 应用启动过程](http://www.jianshu.com/p/ec4a9b3d2576)一文。

## Info.plist & Capabilities & Persistence

- Info.plist 中有 App 的许多设置项，本质为 XML 文件。
- Capabilities 中有 App 的服务器和互用性方面的设置，部分设置需要完整的开发者会员资格。
- iOS 持久化：
  - UserDefaults
  - Core Data
  - Archiving 归档
  - SQLite
  - File System 文件系统

### Archiving 归档

- 适用于任何类型的对象。
- 需要对象遵守 NSCoding 协议：

```Swift
public func encode(with aCoder: NSCoder)
public init?(coder aDecoder: NSCoder)
```

### SQLite

- SQLite 快速，占用内存小，可信赖，且开源。
- 不适合视频，音频，图片等。
- 非基于服务器技术，不适于并发，但在移动端问题不大。
- API 类 C 语言，非面向对象。
- Core Data 默认底层即 SQLite。

## File System 文件系统

- 在 Unix 文件系统中访问文件：
  1. 得到根路径的 URL
  2. 添加文件名到 URL
  3. 读写文件
  4. 通过 FileManager 管理文件系统
- 路径起始为：`/`
- 由于文件保护，并非所有文件均可见。
- 操作仅限应用自己的「沙盒（Sandbox）」。
  - 安全：其他 App 不会破坏该 App
  - 隐私：其他 App 不能访问该 App 数据
  - 易清空：当删除 App，所有文件一同被删除
- 「沙盒」中有什么？
  - 应用包目录（Application bundle directory）：二进制，.storyboards，.jpg 等，该目录不可写。
  - 文档目录（Documents directory）：保存用户创建的永久数据。
  - 缓存目录：保存缓存文件，该目录不会被 iTunes 备份
  - 其他目录

```Swift
// iOS 返回一条 URL，与 macOS 不同
let urls: [URL] = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                                           in: .userDomainMask)
```

- `URL`：

```Swift
func appendingPathComponent(String) -> URL funcappendingPathExtension(String)->URL

var isFileURL: Bool
func resourceValues(for keys: [URLResourceKey]) throws -> [URLResourceKey:Any]?
```

- `Data`：

```Swift
// 读／写二进制数据到文件
init?(contentsOf: URL)
func write(to url: URL, atomically: Bool) -> Bool
```

- `FileManager`：
  - 线程安全。

```Swift
func createDirectory(at url: URL,
withIntermediateDirectories: Bool,
attributes: [String:Any]? = nil // permissions, etc.
) -> Bool throws
func isReadableFile(atPath: String) -> Bool
```

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
- [浅谈 iOS 应用启动过程](http://www.jianshu.com/p/ec4a9b3d2576)
