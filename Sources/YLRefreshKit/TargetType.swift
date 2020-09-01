//
//  TargetType.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import YLStateMachine

public protocol TargetType: Hashable {
    /// 是否能进行下拉刷新。注意，不是指是否遵循 Refreshable 协议。
    var isRefreshable: Bool { get }
    /// 更新 target
    mutating func update(with action: RefreshAction, targetInfo: Any?)
}

extension TargetType {
    public var isRefreshable: Bool { true }
    public mutating func update(with action: RefreshAction, targetInfo: Any?) { }
}
