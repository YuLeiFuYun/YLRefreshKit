//
//  RefreshOperator.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import YLStateMachine

open class RefreshOperator<
    DS: DataSourceType, NM: NetworkManagerType
>: OperatorType where DS.Model == NM.Model
{
    
    public private(set) var dataSource: DS
    
    public private(set) var networkManager: NM
    
    public private(set) var target: NM.Target
    
    public init(dataSource: DS, networkManager: NM, target: NM.Target) {
        self.dataSource = dataSource
        self.networkManager = networkManager
        self.target = target
    }
    
    open func startTransition(_ state: RefreshState) { }
    
    open func endTransition(_ state: RefreshState) { }
    
    open func transition(with action: RefreshAction, completion: @escaping (RefreshState) -> Void) {
        target.update(with: action, targetInfo: dataSource.targetInfo)
        
        networkManager.request(target: target) {
            [unowned self] (result: Result<DS.Model, NM.E>) in
            
            switch result {
            case .success(let model):
                switch action {
                case .pullToRefresh:
                    self.dataSource.model = model
                case .loadingMore:
                    // 加载更多发生在最后一个 section 中
                    let last = model.data!.count - 1
                    self.dataSource.model!.data![last] += model.data!.last!
                }
                
                // 传递刷新状态
                let state: RefreshState = (model.nextPage == nil) ? .populated : .paginated
                completion(state)
            case .failure(let error):
                completion(self.errorHandling(error))
            }
        }
    }
    
    open func errorHandling(_ error: Error) -> RefreshState {
        // 错误处理
        // ...
        return .error(error)
    }
    
}
