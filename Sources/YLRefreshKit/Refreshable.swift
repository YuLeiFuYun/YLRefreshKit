//
//  Refreshable.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import UIKit
import YLStateMachine

public protocol Refreshable {
    associatedtype DS: DataSourceType
    associatedtype NM: NetworkManagerType where DS.Model == NM.Model
    
    var refreshStateMachine: StateMachine<RefreshOperator<DS, NM>>! { get set }
    var tableView: UITableView? { get set }
    var collectionView: UICollectionView? { get set }
    
    func bindRefreshStateMachine()
    func bindRefreshStateMachine(_ completion: @escaping () -> Void)
}

extension Refreshable where Self: UIViewController {
    public func bindRefreshStateMachine() {
        refreshStateMachine.completionHandler = { [weak self] in
            guard
                let self = self,
                !self.refreshStateMachine.currentState.isError
            else { return }

            self.tableView?.reloadData()
            self.tableView?.separatorStyle = .singleLine
            
            self.collectionView?.reloadData()
        }
    }
    
    public func bindRefreshStateMachine(_ completion: @escaping () -> Void) {
        refreshStateMachine.completionHandler = { [weak self] in
            guard
                let self = self,
                !self.refreshStateMachine.currentState.isError
            else { return }

            self.tableView?.reloadData()
            self.tableView?.separatorStyle = .singleLine
            
            self.collectionView?.reloadData()
            
            
            completion()
        }
    }
}
