//
//  TViewController.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLExtensions
import YLStateMachine
import YLRefreshKit

class TViewController<Model: ModelType, DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>: UIViewController, Refreshable {
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    var refreshStateMachine: StateMachine<Operator>!
    var viewModel: TViewModel<Model>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView!.separatorStyle = .none
        tableView!.dataSource = viewModel
        
        if Model.tCells != nil {
            tableView!.registerCells(with: Model.tCells!)
        }
        
        if Model.tNibs != nil {
            tableView!.registerNibs(with: Model.tNibs!)
        }
        
        view.addSubview(tableView!)
        
        tableView!.setAutoRefresh(with: refreshStateMachine)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView!.frame = view.frame
    }
    
}
