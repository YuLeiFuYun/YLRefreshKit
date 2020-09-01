//
//  FirstViewController.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLRefreshKit

class FirstViewController: TViewController<FirstViewModel, NetworkManager<EmojiModel>, CustomRefreshOperator<FirstViewModel, NetworkManager<EmojiModel>>> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshableView?.delegate = self
        refreshableView?.setAutoRefresh(refreshStateMachine: refreshStateMachine)
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let refreshOperator = CustomRefreshOperator(dataSource: SecondViewModel(), networkManager: NetworkManager<NumberModel>(), target: Target.second(page: 1))
        let secondViewController = SecondViewController(refreshOperator: refreshOperator)
        // 给 target 传递一些信息
        secondViewController.refreshStateMachine.operator.dataSource.targetInfo = "some info"
        navigationController?.pushViewController(secondViewController, animated: true)
    }
}

