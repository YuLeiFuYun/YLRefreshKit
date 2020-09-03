//
//  TViewController.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import UIKit
import YLExtensions
import YLStateMachine

open class TViewController<DS: DataSourceType, NM: NetworkManagerType, RO: RefreshOperator<DS, NM>>: UIViewController, Refreshable where DS.Model == NM.Model {
    
    public var refreshableView: UIScrollView? = UITableView()
    public var refreshStateMachine: StateMachine<RefreshOperator<DS, NM>>!
    
    public convenience init(refreshOperator: RO) {
        self.init()
        
        refreshStateMachine = StateMachine(operator: refreshOperator)
        bindRefreshStateMachine()
    }
    
    public convenience init(refreshOperator: RO, afterRefreshed: @escaping () -> Void) {
        self.init()
        
        refreshStateMachine = StateMachine(operator: refreshOperator)
        bindRefreshStateMachine(afterRefreshed)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tableView = refreshableView as? UITableView else { return }
        
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        // 防止出现多余的分割线
        tableView.tableFooterView = UIView()
        tableView.dataSource = refreshStateMachine.operator.dataSource as? UITableViewDataSource
        
        if DS.Model.tCells != nil {
            tableView.registerCells(with: DS.Model.tCells!)
        }
        
        if DS.Model.tNibs != nil {
            tableView.registerNibs(with: DS.Model.tNibs!)
        }
        
        view.addSubview(tableView)
    }
    
}
