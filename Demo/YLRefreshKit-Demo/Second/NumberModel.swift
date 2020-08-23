//
//  NumberModel.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLExtensions

struct NumberModel {
    let numbers: [Int]
    let nextPage: Int?
}

extension NumberModel: ModelType {
    static var tCells: [UITableViewCell.Type]? {
        [UITableViewCell.self]
    }
}
