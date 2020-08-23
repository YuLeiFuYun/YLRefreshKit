//
//  SecondViewController.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/23.
//

import UIKit

class SecondViewController: TViewController<NumberModel, SecondViewModel, XRefreshOperator<SecondViewModel>> {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView!.frame = view.frame
    }

}
