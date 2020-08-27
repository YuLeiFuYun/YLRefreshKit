//
//  AutoRefreshable.swift
//  RefreshKit
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLPullToRefreshKit
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
        configRefreshHeader(container: self) { [unowned self] in
            refreshStateMachine.trigger(.pullToRefresh) {
                switch refreshStateMachine.currentState {
                case .error:
                    // 出错了
                    self.switchRefreshHeader(to: .normal(.failure, 0.5))
                case .paginated:
                    // 有下一页
                    self.switchRefreshHeader(to: .normal(.success, 0.5))
                default:
                    // 没有下一页了
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
    }
}
