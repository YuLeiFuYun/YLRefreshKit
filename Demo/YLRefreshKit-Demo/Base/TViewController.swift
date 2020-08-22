//
//  TViewController.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLExtensions
import YLStateMachine
import YLRefreshKit

class TViewController<Model: ModelType, DataSource: DataSourceType, Operator: RefreshOperator<DataSource>>: UIViewController, Refreshable, UITableViewDelegate {
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    var refreshStateMachine: StateMachine<Operator>!
    var viewModel: TViewModel<Model>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView!.separatorStyle = .none
        tableView!.dataSource = viewModel
        tableView!.delegate = self
        
        if let model = viewModel.model {
            if model.tCells != nil {
                tableView!.registerCells(with: model.tCells!)
            }
            
            if model.tNibs != nil {
                tableView!.registerNibs(with: model.tNibs!)
            }
        }
        
        tableView!.setAutoRefresh(with: refreshStateMachine)
        view.addSubview(tableView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView!.frame = view.frame
    }
    
}
