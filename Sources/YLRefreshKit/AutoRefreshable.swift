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
        with refreshStateMachine: StateMachine<Operator>,
        completion: (() -> Void)?
    )
    
    func setAutoRefresh<DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>(
        with refreshStateMachine: StateMachine<Operator>,
        headerAnimator: ESRefreshAnimatorProtocol & ESRefreshProtocol,
        completion: (() -> Void)?
    )
    
    func setAutoRefresh<DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>(
        with refreshStateMachine: StateMachine<Operator>,
        footerAnimator: ESRefreshAnimatorProtocol & ESRefreshProtocol,
        completion: (() -> Void)?
    )
    
    func setAutoRefresh<DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>(
        with refreshStateMachine: StateMachine<Operator>,
        headerAnimator: ESRefreshAnimatorProtocol & ESRefreshProtocol,
        footerAnimator: ESRefreshAnimatorProtocol & ESRefreshProtocol,
        completion: (() -> Void)?
    )
}

extension UIScrollView: AutoRefreshable {
    public func setAutoRefresh<DataSource, Operator>(
        with refreshStateMachine: StateMachine<Operator>,
        completion: (() -> Void)?
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
                
                completion?()
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
                
                completion?()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.refreshIdentifier == nil {
                self.es.startPullToRefresh()
            } else {
                self.es.autoPullToRefresh()
            }
        }
    }
    
    public func setAutoRefresh<DataSource, Operator>(
        with refreshStateMachine: StateMachine<Operator>,
        headerAnimator: ESRefreshAnimatorProtocol & ESRefreshProtocol,
        completion: (() -> Void)?
    ) where DataSource : DataSourceType, Operator : RefreshOperator<DataSource> {
        es.addPullToRefresh(animator: headerAnimator) {
            refreshStateMachine.trigger(.pullToRefresh) { [unowned self] in
                if case .paginated = refreshStateMachine.currentState {
                    // 有下一页
                    self.es.stopPullToRefresh()
                } else {
                    // 没有下一页了
                    self.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
                }
                
                completion?()
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
                
                completion?()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.refreshIdentifier == nil {
                self.es.startPullToRefresh()
            } else {
                self.es.autoPullToRefresh()
            }
        }
    }
    
    public func setAutoRefresh<DataSource, Operator>(
        with refreshStateMachine: StateMachine<Operator>,
        footerAnimator: ESRefreshAnimatorProtocol & ESRefreshProtocol,
        completion: (() -> Void)?
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
                
                completion?()
            }
        }
        
        es.addInfiniteScrolling(animator: footerAnimator) {
            refreshStateMachine.trigger(.loadingMore) { [unowned self] in
                if case .paginated = refreshStateMachine.currentState {
                    // 有下一页
                    self.es.stopLoadingMore()
                } else {
                    // 没有下一页了
                    self.es.noticeNoMoreData()
                }
                
                completion?()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.refreshIdentifier == nil {
                self.es.startPullToRefresh()
            } else {
                self.es.autoPullToRefresh()
            }
        }
    }
    
    public func setAutoRefresh<DataSource, Operator>(
        with refreshStateMachine: StateMachine<Operator>,
        headerAnimator: ESRefreshAnimatorProtocol & ESRefreshProtocol,
        footerAnimator: ESRefreshAnimatorProtocol & ESRefreshProtocol,
        completion: (() -> Void)?
    ) where DataSource : DataSourceType, Operator : RefreshOperator<DataSource> {
        es.addPullToRefresh(animator: headerAnimator) {
            refreshStateMachine.trigger(.pullToRefresh) { [unowned self] in
                if case .paginated = refreshStateMachine.currentState {
                    // 有下一页
                    self.es.stopPullToRefresh()
                } else {
                    // 没有下一页了
                    self.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
                }
                
                completion?()
            }
        }
        
        es.addInfiniteScrolling(animator: footerAnimator) {
            refreshStateMachine.trigger(.loadingMore) { [unowned self] in
                if case .paginated = refreshStateMachine.currentState {
                    // 有下一页
                    self.es.stopLoadingMore()
                } else {
                    // 没有下一页了
                    self.es.noticeNoMoreData()
                }
                
                completion?()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.refreshIdentifier == nil {
                self.es.startPullToRefresh()
            } else {
                self.es.autoPullToRefresh()
            }
        }
    }
}
