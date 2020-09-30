//
//  NumberModel.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLExtensions

struct NumberModel: ModelType {
    var numbers: [Int]
    let nextPage: Int?
    var pageablePropertyPath: WritableKeyPath<NumberModel, [Int]>? {
        return \NumberModel.numbers
    }
    var data: [[Any]] {
        return [numbers]
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
