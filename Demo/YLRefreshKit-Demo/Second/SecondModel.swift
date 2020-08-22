//
//  SecondModel.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import UIKit

class SecondViewModel: TViewModel<NumberModel> {
    override var model: NumberModel? {
        didSet {
            guard let model = model else { return }
            
            if oldValue == nil {
                // 刷新
                numbers = model.numbers
            } else {
                // 加载更多
                numbers += model.numbers
            }
        }
    }
    
    var numbers: [Int] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier)!
        cell.textLabel?.text = "index: \(numbers[indexPath.row])"
        
        return cell
    }
}
