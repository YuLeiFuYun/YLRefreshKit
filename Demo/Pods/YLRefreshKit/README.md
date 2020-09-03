![logo](logo.png)

YLRefreshKit 通过协议对 Model、Cell、NetworkManager 及 ViewController 等进行了规范，再藉由状态机勾连起各个部分，实现了刷新操作的自动化。通过使用它，你不需要再向 ViewModel 或 Controller 写任何刷新代码，它会自动帮你完成刷新操作。



## Requirements

* iOS 13.0+
* Swift 5.1+



## Installation

### Cocoapods

To integrate YLRefreshKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target 'MyApp' do
  # your other pod
  # ...
  pod 'YLRefreshKit'
end
```

Run `pod install` to build your dependencies.



## Usage

首先，让你的 Model 遵循并满足 ModelType 协议：

```swift
import YLExtensions

struct SomeModel: ModelType {
    let something: [Something]
    
    // 可选属性
    var nextPage: Int?
    // 必要属性
    var data: [[Any]]?
    
    // 创建一个初始化方法初始化 data
    init(something: [Something]) {
        self.something = something
        self.data = [something]
    }
}

extension Something {
    // 若是 UITableView
    
    static var tCells: [UITableViewCell.Type]? {
        // 所有以纯代码形式创建的 cell 类型
        [ACell.self, BCell.self]
    }
    
    static var tNibs: [UITableViewCell.Type]? {
        // 所有以 nib 形式创建的 cell 类型
        [CCell.self, DCell.self]
    }
    // 必须实现
    static var tAll: [UITableViewCell.Type]? {
        // 所有 cell 类型，以显示顺序排列
        [ACell.self, BCell.self, CCell.self, DCell.self]
    }
    
    // 若是 UICollectionView
    
    static var cCells: [UICollectionViewCell.Type]? {
        // 所有以纯代码形式创建的 cell 类型
        ...
    }
    
    static var cNibs: [UICollectionViewCell.Type]? {
        // 所有以 nib 形式创建的 cell 类型
        ...
    }
    // 必须实现
    static var cAll: [UICollectionViewCell.Type]? {
        // 所有 cell 类型，以显示顺序排列
        ...
    }
    
    static var headViews: [UICollectionReusableView.Type]? {
        ...
    }
    
    static var footerViews: [UICollectionReusableView.Type]? {
        ...
    }
    
    static var headerNibs: [UICollectionReusableView.Type]? {
        ...
    }
    
    static var footerNibs: [UICollectionReusableView.Type]? {
        ...
    }
}
```

接着，让 NetworkManager 遵循并实现 NetworkManagerType 协议：

```swift
struct NetworkManager<SomeModel>: NetworkManagerType {
    // 需要一个遵循 TargetType 协议的类型，假设 Target 这个类型满足要求(TargetType 的介绍在下面)
    // 一个遵循 Error 协议的类型
    // 返回值是可选的，它可以是任何类型，以 Somethig 来称呼它吧
    func request(target: Target, completion: @escaping (Result<SomeModel, SomeError>) -> Void) {
        ...
    }
    
    // 也可以是这样
    func request(target: Target, completion: @escaping (Result<SomeModel, SomeError>) -> Void) -> Something {
        ...
    }
}
```

以 table view 页面为例（collection view 与之类似），为了代码复用，我们创建一个 TViewModel：

```swift
import YLExtensions
import YLRefreshKit

class TViewModel<Model: ModelType>:
    NSObject,
    DataSourceType,
    UITableViewDataSource
{
    // DataSourceType 的要求
    var model: Model?
    var targetInfo: Any?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model == nil ? 0 : model!.data!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model == nil ? 0 : model!.data![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: Model.tAll!)
        cell.configure(model!.data![indexPath.section][indexPath.row])
        
        return cell
    }
}
```

于是，SomeViewModel 可以这样写：

```swift
class SomeViewModel: TViewModel<SomeModel> {}
```

创建一个遵循 NetworkManagerType 的 NetworkManager：

```swift
struct NetworkManager<Model: ModelType>: NetworkManagerType {
    func request(target: Target, completion: @escaping (Result<Model, Error>) -> Void) {
        switch target {
        case .first:
            ...
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(.success(model as! Model))
            }
        case .second(let page):
            ...
            let nextPage = ...
            let model = SecondModel(model: ..., nextPage: nextPage)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(.success(model as! Model))
            }
            ...
    }
}
```



如果你需要进行错误处理或在刷新前后进行一些操作，请创建一个继承自 RefreshOperator 的子类并重写你需要的方法（如果没有这些需求，直接使用 RefreshOperator 即可）：

```swift
import YLRefreshKit

class CustomRefreshOperator<DS: DataSourceType, NM: NetworkManagerType>: RefreshOperator<DS, NM> where DS.Model == NM.Model {
    override func startTransition(_ state: RefreshState) {
        print("startTransition")
    }
    
    override func endTransition(_ state: RefreshState) {
        print("endTransition")
    }
    
    override func errorHandling(_ error: Error) -> RefreshState {
        // 错误处理
        print("errorHandling")
        return .error(error)
    }
}
```

接下来，创建你的 view controller：

```swift
// 如果是一个 table view 页面，请继承 TViewController（collection view 页面请继承 CViewController，scroll view 页面继承 SViewController）：
import YLRefreshKit

class FirstViewController: TViewController<SomeViewModel, NetworkManager<SomeModel>, CustomRefreshOperator<SomeViewModel, NetworkManager<SomeModel>>> { 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view 默认占据整个页面，你可以在此调整其大小
        refreshableView!.frame = ...
        // 或者，你想在页面添加一些 view
        ..
        view.addSubView(...)
        ...
        // 如果要进行页面跳转
        refreshableView!.delegate = self
        
        // 设置自动刷新
        refreshableView!.setAutoRefresh(refreshStateMachine: refreshStateMachine)
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let refreshOperator = CustomRefreshOperator(dataSource: SecondViewModel(), networkManager: NetworkManager<SecondModel>(), target: SomeTarget.second(page: 1))
        // 创建 Controller
        let secondViewController = SecondViewController(refreshOperator: refreshOperator)
        // 如果你想在刷新完成后进行一些处理的话
        let secondViewController = SecondViewController(refreshOperator: refreshOperator) {
            ...
        }
        
        // 如果想给 target 传递一些信息
        secondViewController.refreshStateMachine.operator.dataSource.targetInfo = "some info"
        
        navigationController?.pushViewController(secondViewController, animated: true)
    }
}

// 如果你希望自定义 table view 的 header 或 footer
extension UIScrollView {
    func customAutoRefresh<DS: DataSourceType, NM: NetworkManagerType>(refreshStateMachine: StateMachine<RefreshOperator<DS, NM>>) where DS.Model == NM.Model {
        let header = ..
        let footer = ..
        // 然后请参照 AutoRefreshable.swift 页面中的实现
        ...
    }
}
// 之后在 view controller 中调用
override func viewDidLoad() {
    super.viewDidLoad()
    ...
    refreshableView!.customAutoRefresh(refreshStateMachine: refreshStateMachine)
}
```

接着，创建一个 target 让它遵循并实现 TargetType 协议：

```swift
import YLRefreshKit

enum SomeTarget: TargetType {
    case first(page: Int)
    case second(page: Int)
    ...
    
    // 是否能进行下拉刷新。注意，不是指是否遵循 Refreshable 协议.
    var isRefreshable: Bool {
        switch self {
            ...
        }
    }
    
    // 更新 target
    mutating func update(with action: RefreshAction, targetInfo: Any?) {
        guard isRefreshable else { return }
        print("targetInfo: \(String(describing: targetInfo))")
        
        switch action {
        case .pullToRefresh:
            switch self {
            case .first:
                self = .first(page: 1)
            case .second:
                self = .second(page: 1)
            }
        case .loadingMore:
            switch self {
            case .first(let page):
                self = .first(page: page + 1)
            case .second(let page):
                self = .second(page: page + 1)
            }
        }
    }
}
```

最后，在 Cell 中重写 `configure(_:)` 方法：

```swift
class SomeCell: UITableViewCell {
    override func configure(_ model: Any?) {
        ...
    }
}
```



## License

YLRefreshKit is released under the MIT license. See LICENSE for details.