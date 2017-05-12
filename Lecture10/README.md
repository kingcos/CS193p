# CS193p 查漏补缺（七）Lecture 10

> Developing iOS 10 Apps with Swift - CS193p

- Info:
 - Swift 3.1
 - Xcode 8.3.1
 - macOS 10.12.4

## Preface

CS193p 是斯坦福大学的一门公开课，今年 iOS 10 & Swift 3.0 的版本如约而至，还是 Paul 老爷爷带课。之前虽然也有听过他的课，但没有坚持下来，也没有做相应的笔记。为了方便交流分享，我在 GitHub 建立了一个 Repo：[https://github.com/kingcos/CS193P_2017](https://github.com/kingcos/CS193P_2017)，会将课上的代码 Commit，也会分享笔记、心得。

由于之前学过 Swift，也相信学习这门课的同学应当有一些 Swift 基础，所以定为查漏补缺，目标只将难点、重点、常用点总结。

## Core Data

> Core Data 是 macOS 和 iOS SDK 中的一个非常强大且庞大的框架，该处仅涉及老师所讲内容，未来深入学习会另行记录。据我所知，objc.io 和 R.W. 均有 Core Data 相关书籍，想深入了解学习的同学可以去查阅。

- Core Data 是面向对象的数据库。
- Core Data 的底层是 SQLite，也可以是 XML 或直接为内存。
- 实体：Entities，属性：Attributes，关系：Relationships。

### NSManagedObjectContext

- NSManagedObjectContext 是所有 Core Data 操作的核心，是处理被管理对象的内存暂存器。
- 若创建项目时勾选「Use Core Data」后，可以从 AppDelegate 得到 NSPersistentContainer，并可以在其 viewContext 属性中得到 NSManagedObjectContext。

```Swift
let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer let context: NSManagedObjectContext = container.viewContext
```

- 上述写法虽然可行，但比较繁琐，可以在 AppDelegate.swift 中定义静态变量以方便后续使用：

```Swift
static var persistentContainer: NSPersistentContainer {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
}
// let coreDataContainer = AppDelegate.persistentContainer

static var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
}
// let context = AppDelegate.viewContext
```

### NSManagedObject

- 向数据库中插入数据：

```Swift
let context = AppDelegate.viewContext
// NSEntityDescription 类方法返回 NSManagedObject 实例
// 新插入的对象起始为 nil，除非指定默认值
let tweet: NSManagedObject =
      NSEntityDescription.insertNewObject(forEntityName: “Tweet”, into: context)
```

- 数据库中所有对象的类型均为 NSManagedObjects 或其子类。
- NSManagedObject 的实例是实体的 Core Data 中数据模型（Data Model）实体的表现形式。
- 默认使用 KVC 访问 NSManagedObject 实例的属性，Key 为属性名，Value 为数据库中存储的值。
- 类型：
  - 数字——Double，Int，等（勾选「Use Scalar Type」）
  - 二进制数据——NSData
  - 日期时间——NSDate
  - 一对多关系——NSSet（可以转型为 Set<NSManagedObject>）
  - 一对一关系——NSManagedObject
- 默认情况，属性对应代码中的对象，例如 NSNumber，如果需要为 Swift 的普通类型，可以勾选「Use Scalar Type」（数量值已默认勾选）
- 所有改变只发生在内存中，直到调用 `save()`。

```Swift
do {
    try context.save()
} catch {
    // 处理 error
}
```

- KVC 不安全，因为需要使用容易出错的字符串，取代方法：
- 1.图形编辑器中，将实体的 Codegen 类型改为 「Category/Extension」（「Manual/None」选项意味着将使用 KVC 手动访问属性），创建与实体同名（推荐）的 NSManagedObject 子类。多 Module 中，需要设置 Module「Current Product Module」

```Swift
// 取代 NSEntityDescription 创建实体
if let tweet = Tweet(context: context) {
    // 比 setValue("140 characters of pure joy", forKey: "text") 更安全，美观
    tweet.text = "140 characters of pure joy"
    tweet.created = Date() as NSDate
    // 可以一次性双向建立关系 Relationship
    let joe = TwitterUser(context: tweet.managedObjectContext)
    // 设置一对多关系
    tweet.tweeter = joe // joe.addToTweets(tweet)
    // 取代 value(forKeyPath:)
    tweet.tweeter.name = "Joe Schmo"
}
```

- 2.（Core Data Tutorial 推荐）选中图表编辑器中的实体，「Editor-Create NSManagedObject Subclass...」，具体可参考该书。

### 删除

- `delete()` 后，关系 Relationship 同样会更新。删除后，不可强引用 tweet。
- NSManagedObject 子类可以重写 `prepareForDeletion()`。

```Swift
managedObjectContext.delete(_ object: tweet)
```

### 查询

- NSFetchRequest
  - Entity 取回的实体
  - NSSortDescriptor 排序描述符
  - NSPredicate 断言

```Swift
// 该处无法推断类型，需要明确类型；返回数据库中该类型的全部对象
let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
// NSSortDescriptor 排序描述符：selector 为比较的方法
let sortDescriptor = NSSortDescriptor(
    key: “screenName”, ascending: true,
    selector: #selector(NSString.localizedStandardCompare(_:))
)
request.sortDescriptors = [sortDescriptor]
// NSPredicate 断言，筛选结果
let searchString = “foo”
let predicate1 = NSPredicate(format: “text contains[c] %@“, searchString)
let predicate2 = NSPredicate(format: “tweeter.screenName = %@“, “CS193p”)
// NSCompoundPredicate 组合断言，AND 或 OR
let predicates = [predicate1, predicate2]
let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
// 另有函数断言 tweets.@count > 5（@count 是数据库本身执行的函数）
request.predicate = andPredicate

let context = AppDelegate.viewContext
let recentTweeters = try? context.fetch(request)
```

### Faulting（断层）

```Swift
for user in recentTweeters {
    // 未断层对象
    print(“fetched user \(user)”)
    // 当只有访问 NSManagedObject 的内部数据才断层
    print(“fetched user named \(user.name)”)
}
```

### 线程安全

- NSManagedObjectContext 不是线程安全的，但 Core Data 非常快；其使用以队列为基的并发模型，通常只在主队列和 AppDelegate.viewContext 中使用。
- NSManagedObjectContext 的线程安全访问 `context.performBlock {}`。

```Swift
AppDelegate.persistentContainer.performBackgroundTask { context in
    // 非主队列，不可进行 UI 操作
    try? context.save()
}
```

### NSFetchedResultsController

- UITableViewDataSource 中使用 NSFetchedResultsController：

```Swift
var fetchedResultsController = NSFetchedResultsController
func numberOfSectionsInTableView(sender: UITableView) -> Int {
     return fetchedResultsController?.sections?.count ?? 1
}

func tableView(sender: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController?.sections, sections.count > 0 {
        return sections[section].numberOfObjects
    } else {
        return 0
    }
}

func tableView(_ tv: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tv.dequeue...
    if let obj = fetchedResultsController.object(at: indexPath) {
    // obj will be an NSManagedObject (or subclass thereof) that fetches into this row
    // obj 为 NSManagedObject 或
    }
    return cell
}
```


```Swift
let frc = NSFetchedResultsController<Tweet>( // note this is a generic type fetchRequest: request,
managedObjectContext: context,
sectionNameKeyPath: keyThatSaysWhichAttributeIsTheSectionName,
cacheName: “MyTwitterQueryCache”)
```

## Reference

- [CS193P_2017](https://github.com/kingcos/CS193P_2017)
- [Core Data Tutorial v3.0](https://store.raywenderlich.com/products/core-data-by-tutorials)
