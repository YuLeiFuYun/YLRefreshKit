//
//  FirstViewController.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLRefreshKit

class FirstViewController: TViewController<FirstViewModel, NetworkManager<EmojiModel>> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView!.delegate = self
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = Target.second(page: 1).viewController as? SecondViewController else { return }
        viewController.refreshStateMachine.operator.dataSource.targetInfo = "some info"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

