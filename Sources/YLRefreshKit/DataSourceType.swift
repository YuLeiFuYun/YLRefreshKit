//
//  DataSourceType.swift
//  RefreshKit
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLExtensions

public protocol DataSourceType {
    associatedtype Model: ModelType
    var model: Model? { get set }
}
