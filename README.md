# YLRefreshKit
为了实现自动刷新及统一刷新操作，YLRefreshKit 对项目的各个方面都有要求：Model、Cell、ViewModel、NetworkManager、ViewController，与其把它看作一个库，不如把它当作项目编写规范来看，只要按照这个规范的要求编写项目，就能获得自动刷新的功能并实现刷新操作的统一处理。由于使用步骤较多且使用了相当数量的协议，YLRefreshKit 可能不是很容易上手，非常建议你通过 Demo 来学习如何使用它。



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

### Swift Package Manager

Select File > Swift Packages > Add Package Dependency. Enter `https://github.com/YuLeiFuYun/YLRefreshKit.git` in the "Choose Package Repository" dialog.



## Usage

让 Model 遵循并满足 ModelType 协议：

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
        data = [something]
    }
}

extension Something {
    static var tCells: [UITableViewCell.Type]? {
        // 所有以纯代码形式创建的 cell 类型
        [ACell.self, BCell.self]
    }
    
    static var tNibs: [UITableViewCell.Type]? {
        // 所有以 nib 形式创建的 cell 类型
        [CCell.self, DCell.self]
    }
    
    static var tAll: [UITableViewCell.Type]? {
        // 所有 cell 类型，以显示顺序排列
        [ACell.self, BCell.self, CCell.self, DCell.self]
    }
}
```

在 cell 中重写 `configure(_:)` 方法：

```swift
class SomeCell {
    ...
    override func configure(_ model: Any?) {
        ...
    }
}
```

创建一个 TViewModel（适用于 table view 的 ViewModel。collection view 与之类似。）：

```swift
import YLExtensions
import YLRefreshKit

class TViewModel<Model: ModelType>:
    NSObject,
    DataSourceType,
    UITableViewDataSource,
    UITableViewDataSourcePrefetching
{
    // DataSourceType 的要求
    var model: Model?
    
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
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}
```

于是，SomeViewModel 可以这样写：

```swift
class SomeViewModel: TViewModel<SomeModel> {}

extension SomeViewModel {
    // table view data source prefetching
    ...
}
```

NetworkManager 的形式：

```swift
enum Target {
    case first(page: Int)
    case second(page: Int)
}

struct NetworkManager {
    func request<T>(target: Target, completion: @escaping (Result<T, Error>) -> Void) {
        switch target {
        case .first(let page):
            ...
            DispatchQueue.main.async {
                completion(.success(model as! T))
            }
        case .second(let page):
            ...
        }
    }
}
```

创建 SomeRefreshOperator 继承自 RefreshOperator：

```swift
import YLExtensions
import YLRefreshKit

class SomeRefreshOperator<DataSource: DataSourceType>: RefreshOperator<DataSource> {
    private let networkManager = NetworkManager()
    private var target: Target
    
    override init(dataSource: DataSource) {
        switch dataSource {
        case is FirstViewModel:
            target = .first(page: 1)
        case is SecondViewModel:
            target = .second(page: 1)
        default:
            fatalError()
        }
        
        super.init(dataSource: dataSource)
    }
    
    override func transition(with action: RefreshAction, completion: @escaping (RefreshState) -> Void) {
        updateTarget(action: action)
        
        networkManager.request(target: target) {
            [unowned self] (result: Result<DataSource.Model, Error>) in
            switch result {
            case .success(let model):
                switch action {
                case .pullToRefresh:
                    // 处理数据
                    ...
                case .loadingMore:
                    // 处理数据
                    ...
                }
                
                // 传递刷新状态
                let state: RefreshState = (model.nextPage == nil) ? .populated : .paginated
                completion(state)
            case .failure(let error):
                completion(self.errorHandling(error))
            }
        }
    }
}

private extension SomeRefreshOperator {
    func updateTarget(action: RefreshAction) {
        // 更新 target
        ...
    }
    
    func errorHandling(_ error: Error) -> RefreshState {
        // 处理错误
        ...
        return .error(error)
    }
}
```

为了代码复用，可以创建一个 TViewController：

```swift
import YLExtensions
import YLStateMachine
import YLRefreshKit

class TViewController<Model: ModelType, DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>: UIViewController, Refreshable {
    
    var refreshStateMachine: StateMachine<Operator>!
    var viewModel: TViewModel<Model>!
    
    // Refreshable 的要求
    var tableView: UITableView?
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView!.separatorStyle = .none
        tableView!.dataSource = viewModel
        
        if Model.tCells != nil {
            tableView!.registerCells(with: Model.tCells!)
        }
        
        if Model.tNibs != nil {
            tableView!.registerNibs(with: Model.tNibs!)
        }
        
        view.addSubview(tableView!)
        
        // 设置自动刷新
        tableView!.setAutoRefresh(with: refreshStateMachine)
        // 如果你希望自定义刷新的 header 与 footer，
        // 请参考 YLRefreshKit 中的 AutoRefreshable.swift 页面实现你自己的自动刷新方法。
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView!.frame = view.frame
    }
    
}
```

然后，让 ViewController 继承自 TViewController：

```swift
import YLStateMachine

// FirstViewController 页面
class FirstViewController: TViewController<FirstModel, FirstViewModel, SomeRefreshOperator<FirstViewModel>> {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView!.delegate = self
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 跳转页面
        ...
    }
}

// SecondViewController 页面
class SecondViewController: TViewController<SecondModel, SecondViewModel, SomeRefreshOperator<SecondViewModel>> { }
```

最后，你需要这样创建及配置 ViewController：

```swift
let viewController = FirstViewController()
let viewModel = FirstViewModel()
let refreshOperator = SomeRefreshOperator(dataSource: viewModel)
viewController.viewModel = viewModel
viewController.refreshStateMachine = StateMachine(operator: refreshOperator)
viewController.bindRefreshStateMachine()
// 或者，你需要在刷新后进行一些操作
viewController.bindRefreshStateMachine {
    ...
}
```



## License

YLRefreshKit is released under the MIT license. See LICENSE for details.