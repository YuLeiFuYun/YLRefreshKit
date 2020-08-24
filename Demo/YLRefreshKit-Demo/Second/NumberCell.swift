//
//  NumberCell.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/24.
//

import UIKit

class NumberCell: UITableViewCell {
    override func configure(_ model: Any?) {
        guard let number = model as? Int else { return }
        textLabel?.text = "index: \(number)"
    }
}
