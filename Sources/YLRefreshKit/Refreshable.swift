//
//  Refreshable.swift
//  RefreshKit
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import UIKit
import YLStateMachine

public protocol Refreshable {
    associatedtype DataSource: DataSourceType
    associatedtype Operator: RefreshOperator<DataSource>
    
    var refreshStateMachine: StateMachine<Operator>! { get set }
    var tableView: UITableView? { get set }
    var collectionView: UICollectionView? { get set }
    
    func bindRefreshStateMachine(_ completion: (() -> Void)?)
}

extension Refreshable where Self: UIViewController {
    public func bindRefreshStateMachine(_ completion: (() -> Void)?) {
        refreshStateMachine.completionHandler = { [weak self] in
            guard
                let self = self,
                !self.refreshStateMachine.currentState.isError
            else { return }

            self.tableView?.reloadData()
            self.tableView?.separatorStyle = .singleLine
            
            self.collectionView?.reloadData()
            
            completion?()
        }
    }
}
