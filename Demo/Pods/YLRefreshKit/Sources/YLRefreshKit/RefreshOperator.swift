//
//  RefreshOperator.swift
//  RefreshKit
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLStateMachine

open class RefreshOperator<DataSource: DataSourceType>: OperatorType {
    
    public var dataSource: DataSource
    
    public init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    // The subclass must override this method
    public func transition(with action: RefreshAction, completion: @escaping (RefreshState) -> Void) {
        fatalError()
    }
}
