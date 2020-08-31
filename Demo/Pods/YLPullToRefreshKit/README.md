<p align="center">
 [![Version](https://img.shields.io/cocoapods/v/YLPullToRefreshKit.svg?style=flat)](http://cocoapods.org/pods/YLPullToRefreshKit)  [![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
 [![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-orange.svg)](https://swift.org/package-manager)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)



## Requirements

- iOS 13.0+
- Swift 5.1+



## Features

UITableView/UICollectionView/UIScrollView/UIWebView

- [x] Pull to refresh.
- [x] Pull/Tap to load more.
- [x] Pull left/right to load more(Currently only support chinese)
- [x] Elastic refresh 
- [x] Easy to customize
- [x] English and Chinese



## Install

### CocoaPod

To integrate YLPullToRefreshKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target 'MyApp' do
  # your other pod
  # ...
  pod 'YLPullToRefreshKit'
end
```

Run `pod install` to build your dependencies.

### Swift Package Manager

Select File > Swift Packages > Add Package Dependency. Enter `https://github.com/YuLeiFuYun/YLPullToRefreshKit.git` in the "Choose Package Repository" dialog.



## Useage

> What is a container?
> A container is the object that hold the scrollView reference, most time it is a UIViewController object

#### Pull down to refresh


```swift i
self.tableView.configRefreshHeader(container:self) { [weak self] in
    // success
    self?.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
    // failure
    self?.tableView.switchRefreshHeader(to: .normal(.failure, 0.5))
    
    // if no more data
    self?.tableView.switchRefreshFooter(to: .removed)
}
```

<img src="Screenshot/gif1.gif" width="320">

#### Pull up to load more

Support three mode to fire refresh action  

- [x] Tap
- [x] Scroll
- [x] Scroll and Tap

```swift
self.tableView.configRefreshFooter(container:self) { [weak self] in
	// has more data
    self?.tableView.switchRefreshFooter(to: .normal)
    // no more data
    self?.tableView.switchRefreshFooter(to: .removed)
};
```

<img src="Screenshot/gif2.gif" width="320">

#### Pull left to exit

```swift
scrollView.configSideRefresh(with: DefaultRefreshLeft.left(), container:self, at: .left) {
    self.navigationController?.popViewController(animated: true)
};
```

<img src="Screenshot/gif3.gif" width="200">

#### Pull right to Pop

```swift
let right  = DefaultRefreshRight.right()
right.setText("👈滑动关闭", mode: .scrollToAction)
right.setText("松开关闭", mode: .releaseToAction)
right.textLabel.textColor = UIColor.orange
scrollView.configSideRefresh(with: right, container:self, at: .right) { [weak self] in
    self?.navigationController?.popViewController(animated: true)
};
```

<img src="Screenshot/gif4.gif" width="200">

#### Config the default refresh text

YLPullToRefreshKit offer `SetUp` operator，for example

```swift
let header = DefaultRefreshHeader.header()
header.setText("Pull to refresh", mode: .pullToRefresh)
header.setText("Release to refresh", mode: .releaseToRefresh)
header.setText("Success", mode: .refreshSuccess)
header.setText("Refreshing...", mode: .refreshing)
header.setText("Failed", mode: .refreshFailure)
header.tintColor = UIColor.orange
header.imageRenderingWithTintColor = true
header.durationWhenHide = 0.4
self.tableView.configRefreshHeader(with: header,container:self) { [weak self] in
    delay(1.5, closure: {
        self?.models = (self?.models.map({_ in random100()}))!
        self?.tableView.reloadData()
        self?.tableView.switchRefreshHeader(to: .normal(.success, 0.3))
    })
};
```

#### Customize

You just need to write a `UIView` sub class,and make it conforms to these protocols

- `RefreshableHeader`
- `RefreshableFooter`
- `RefreshableLeftRight` 

For exmaple,to create a custom header

``` swift
    //Height of the refresh header
    func heightForHeader()->CGFloat
    
    //Distance from top when in refreshing state
    func heightForRefreshingState()->CGFloat
   
    //Will enter refreshing state,change view state to refreshing in this function
    func didBeginrefreshingState()

    //The refreshing task is end.Refresh header will hide.Tell user the refreshing result here.
    func didBeginHideAnimation(result:RefreshResult)
    
    //Refresh header is hidden,reset all to inital state here
    func didCompleteHideAnimation(result:RefreshResult)
    
    //Distance to drag to fire refresh action ,default is heightForRefreshingState
    optional func heightForFireRefreshing()->CGFloat
    
    //Percent change during scrolling
    optional func percentUpdateDuringScrolling(percent:CGFloat)
    
    //Duration of header hide animation
    optional func durationOfHideAnimation()->Double
    
```



## License

YLPullToRefreshKit is available under the MIT license. See the LICENSE file for more info.