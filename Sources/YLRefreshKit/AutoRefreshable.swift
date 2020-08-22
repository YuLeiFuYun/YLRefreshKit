//
//  AutoRefreshable.swift
//  RefreshKit
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import ESPullToRefresh
import YLStateMachine

public protocol AutoRefreshable {
    func setAutoRefresh<DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>(
        with refreshStateMachine: StateMachine<Operator>
    )
}

extension UIScrollView: AutoRefreshable {
    public func setAutoRefresh<DataSource, Operator>(
        with refreshStateMachine: StateMachine<Operator>
    ) where DataSource : DataSourceType, Operator : RefreshOperator<DataSource> {
        es.addPullToRefresh {
            refreshStateMachine.trigger(.pullToRefresh) { [unowned self] in
                if case .paginated = refreshStateMachine.currentState {
                    // 有下一页
                    self.es.stopPullToRefresh()
                } else {
                    // 没有下一页了
                    self.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
                }
            }
        }
        
        es.addInfiniteScrolling {
            refreshStateMachine.trigger(.loadingMore) { [unowned self] in
                if case .paginated = refreshStateMachine.currentState {
                    // 有下一页
                    self.es.stopLoadingMore()
                } else {
                    // 没有下一页了
                    self.es.noticeNoMoreData()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.es.startPullToRefresh()
        }
    }
}
