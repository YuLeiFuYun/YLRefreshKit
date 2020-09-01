Pod::Spec.new do |s|
  s.name         = "YLRefreshKit"
  s.version      = "2.1.1"
  s.summary      = "Consolidate and automate refresh operations."
  s.homepage     = "https://github.com/YuLeiFuYun/YLRefreshKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "YuLeiFuYun" => "yuleifuyunn@gmail.com" }
  s.swift_version = "5.1"
  s.platform     = :ios, "13.0"	
  s.source       = { :git => "https://github.com/YuLeiFuYun/YLRefreshKit.git", :tag => s.version }
  s.source_files = "Sources/YLRefreshKit/*.swift"
  s.dependency "YLExtensions"
  s.dependency "YLStateMachine"
  s.dependency 'YLPullToRefreshKit'
end
