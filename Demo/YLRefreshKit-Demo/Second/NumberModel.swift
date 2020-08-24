//
//  NumberModel.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLExtensions

struct NumberModel: ModelType {
    let numbers: [Int]
    let nextPage: Int?
    var data: [[Any]]?
    
    init(numbers: [Int], nextPage: Int?) {
        self.numbers = numbers
        self.nextPage = nextPage
        data = [numbers]
    }
}

extension NumberModel {
    static var tCells: [UITableViewCell.Type]? {
        [NumberCell.self]
    }
    
    static var tAll: [UITableViewCell.Type]? {
        [NumberCell.self]
    }
}
