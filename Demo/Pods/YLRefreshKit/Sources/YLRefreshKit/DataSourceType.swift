//
//  DataSourceType.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import YLExtensions

public protocol DataSourceType {
    associatedtype Model: ModelType
    var model: Model? { get set }
    var targetInfo: Any? { get set }
}
