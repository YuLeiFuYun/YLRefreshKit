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
    var refreshableView: UIScrollView? { get set }
    
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

            if let tableView = self.refreshableView as? UITableView {
                tableView.separatorStyle = .singleLine
                tableView.reloadData()
            } else if let collectionView = self.refreshableView as? UICollectionView {
                collectionView.reloadData()
            }
        }
    }
    
    public func bindRefreshStateMachine(_ completion: @escaping () -> Void) {
        refreshStateMachine.completionHandler = { [weak self] in
            guard
                let self = self,
                !self.refreshStateMachine.currentState.isError
            else { return }

            if let tableView = self.refreshableView as? UITableView {
                tableView.separatorStyle = .singleLine
                tableView.reloadData()
            } else if let collectionView = self.refreshableView as? UICollectionView {
                collectionView.reloadData()
            }
            
            completion()
        }
    }
}
