//
//  FirstViewController.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLStateMachine

class FirstViewController: TViewController<EmojiModel, FirstViewModel, XRefreshOperator<FirstViewModel>> {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView!.frame = view.frame
    }

}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondViewController = SecondViewController()
        let viewModel = SecondViewModel()
        let refreshOperator = XRefreshOperator(dataSource: viewModel)
        secondViewController.viewModel = viewModel
        secondViewController.refreshStateMachine = StateMachine(operator: refreshOperator)
        secondViewController.bindRefreshStateMachine(nil)
        
        navigationController?.pushViewController(secondViewController, animated: true)
    }
}

