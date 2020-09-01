//
//  CViewController.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/9/1.
//

import UIKit
import YLExtensions
import YLStateMachine

open class CViewController<DS: DataSourceType, NM: NetworkManagerType, RO: RefreshOperator<DS, NM>>: UIViewController, Refreshable where DS.Model == NM.Model {
    
    public var refreshableView: UIScrollView? = UICollectionView()
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
        
        guard let collection = refreshableView as? UICollectionView else { return }
        collection.frame = view.bounds
        collection.dataSource = refreshStateMachine.operator.dataSource as? UICollectionViewDataSource
        
        if DS.Model.cCells != nil {
            collection.registerCells(with: DS.Model.cCells!)
        }
        
        if DS.Model.cNibs != nil {
            collection.registerNibs(with: DS.Model.cNibs!)
        }
        
        if DS.Model.headViews != nil {
            collection.registerHeaders(with: DS.Model.headViews!)
        }
        
        if DS.Model.headerNibs != nil {
            collection.registerHeaderNibs(with: DS.Model.headerNibs!)
        }
        
        if DS.Model.footerViews != nil {
            collection.registerFooters(with: DS.Model.footerViews!)
        }
        
        if DS.Model.footerNibs != nil {
            collection.registerFooterNibs(with: DS.Model.footerNibs!)
        }
        
        view.addSubview(collection)
    }
}
