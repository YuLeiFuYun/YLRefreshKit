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
        updateTarget(action: action)
        
        networkManager.request(target: target) {
            [unowned self] (result: Result<DataSource.Model, Error>) in
            switch result {
            case .success(let model):
                switch action {
                case .pullToRefresh:
                    self.dataSource.model = model
                case .loadingMore:
                    self.dataSource.model!.data![0] += model.data![0]
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

private extension XRefreshOperator {
    func updateTarget(action: RefreshAction) {
        switch target {
        case .first(let page):
            let p = (action == .pullToRefresh) ? 1 : page + 1
            target = .first(page: p)
        case .second(let page):
            let p = (action == .pullToRefresh) ? 1 : page + 1
            target = .second(page: p)
        }
    }
    
    func errorHandling(_ error: Error) -> RefreshState {
        print("error handling...")
        return .error(error)
    }
}

