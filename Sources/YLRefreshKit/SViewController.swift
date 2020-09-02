//
//  SViewController.swift
//  Decomposer-Pre
//
//  Created by 玉垒浮云 on 2020/9/2.
//

import UIKit
import YLExtensions
import YLStateMachine

open class SViewController<DS: DataSourceType, NM: NetworkManagerType, RO: RefreshOperator<DS, NM>>: UIViewController, Refreshable where DS.Model == NM.Model {
    
    public var refreshableView: UIScrollView? = UIScrollView()
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
        
        refreshableView!.frame = view.bounds
        refreshableView!.contentSize = view.frame.size
        refreshableView!.showsVerticalScrollIndicator = false
        refreshableView!.backgroundColor = .white
        view.addSubview(refreshableView!)
    }
    
}
