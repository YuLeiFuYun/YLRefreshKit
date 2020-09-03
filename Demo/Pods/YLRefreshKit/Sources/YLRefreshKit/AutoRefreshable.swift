//
//  AutoRefreshable.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import YLPullToRefreshKit
import YLStateMachine

public protocol AutoRefreshable {
    func setAutoRefresh<DS: DataSourceType, NM: NetworkManagerType>(
        refreshStateMachine: StateMachine<RefreshOperator<DS, NM>>
    ) where DS.Model == NM.Model
}

extension UIScrollView: AutoRefreshable {
    public func setAutoRefresh<DS: DataSourceType, NM: NetworkManagerType>(
        refreshStateMachine: StateMachine<RefreshOperator<DS, NM>>
    ) where DS.Model == NM.Model {
        if refreshStateMachine.operator.target.isRefreshable {
            configRefreshHeader(container: self) { [unowned self] in
                refreshStateMachine.trigger(.pullToRefresh) {
                    self.configRefreshFooter(refreshStateMachine: refreshStateMachine)
                    
                    switch refreshStateMachine.currentState {
                    case .error:
                        // 出错了
                        self.switchRefreshHeader(to: .normal(.failure, 0.5))
                    case .paginated:
                        // 有下一页
                        self.switchRefreshHeader(to: .normal(.success, 0.5))
                    default:
                        // 没有下一页了
                        self.switchRefreshHeader(to: .normal(.success, 0.5))
                        self.switchRefreshFooter(to: .removed)
                    }
                }
            }
            
            configRefreshFooter(container: self) { [unowned self] in
                refreshStateMachine.trigger(.loadingMore) {
                    switch refreshStateMachine.currentState {
                    case .populated:
                        // 没有下一页了
                        self.switchRefreshFooter(to: .removed)
                    default:
                        // 有下一页或是出错了
                        self.switchRefreshFooter(to: .normal)
                    }
                }
            }
            
            configRefreshFooter(refreshStateMachine: refreshStateMachine)
        } else {
            refreshStateMachine.trigger(.pullToRefresh)
        }
    }
    
    func configRefreshFooter<DS: DataSourceType, NM: NetworkManagerType>(
        refreshStateMachine: StateMachine<RefreshOperator<DS, NM>>
    ) where DS.Model == NM.Model {
        configRefreshFooter(container: self) { [unowned self] in
            refreshStateMachine.trigger(.loadingMore) {
                switch refreshStateMachine.currentState {
                case .populated:
                    // 没有下一页了
                    self.switchRefreshFooter(to: .removed)
                default:
                    // 有下一页或是出错了
                    self.switchRefreshFooter(to: .normal)
                }
            }
        }
    }
}
