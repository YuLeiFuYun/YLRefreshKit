//
//  AutoRefreshable.swift
//  RefreshKit
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import MJRefresh
import YLStateMachine

public protocol AutoRefreshable {
    func setAutoRefresh<DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>(
        with refreshStateMachine: StateMachine<Operator>
    )
    
    func setAutoRefresh<DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>(
        with refreshStateMachine: StateMachine<Operator>,
        completion: @escaping () -> Void
    )
}

extension UIScrollView: AutoRefreshable {
    public func setAutoRefresh<DataSource, Operator>(
        with refreshStateMachine: StateMachine<Operator>,
        completion: @escaping () -> Void
    ) where DataSource : DataSourceType, Operator : RefreshOperator<DataSource> {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            refreshStateMachine.trigger(.pullToRefresh) { [unowned self] in
                self.mj_footer?.resetNoMoreData()
                self.mj_header?.endRefreshing()
                
                completion()
            }
        })
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            refreshStateMachine.trigger(.loadingMore) { [unowned self] in
                if case .paginated = refreshStateMachine.currentState {
                    // 有下一页
                    self.mj_footer?.endRefreshing()
                } else {
                    // 没有下一页了
                    self.mj_footer?.endRefreshingWithNoMoreData()
                }
                
                completion()
            }
        })
        
        footer.stateLabel?.isHidden = true
        mj_footer = footer
        
        header.isAutomaticallyChangeAlpha = true
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        mj_header = header
        mj_header?.beginRefreshing()
    }
    
    public func setAutoRefresh<DataSource, Operator>(
        with refreshStateMachine: StateMachine<Operator>
    ) where DataSource : DataSourceType, Operator : RefreshOperator<DataSource> {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            refreshStateMachine.trigger(.pullToRefresh) { [unowned self] in
                self.mj_footer?.resetNoMoreData()
                self.mj_header?.endRefreshing()
            }
        })
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            refreshStateMachine.trigger(.loadingMore) { [unowned self] in
                if case .paginated = refreshStateMachine.currentState {
                    // 有下一页
                    self.mj_footer?.endRefreshing()
                } else {
                    // 没有下一页了
                    self.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
        })
        
        footer.stateLabel?.isHidden = true
        mj_footer = footer
        
        header.isAutomaticallyChangeAlpha = true
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        mj_header = header
        mj_header?.beginRefreshing()
    }
}
