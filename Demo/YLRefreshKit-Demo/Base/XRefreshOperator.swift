//
//  XRefreshOperator.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLExtensions
import YLRefreshKit

class XRefreshOperator<DataSource: DataSourceType>: RefreshOperator<DataSource> {
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
        fatalError()
    }
}

