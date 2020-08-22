//
//  TViewModel.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLExtensions
import YLRefreshKit

class TViewModel<Model: ModelType>:
    NSObject,
    DataSourceType,
    UITableViewDataSource,
    UITableViewDelegate,
    UITableViewDataSourcePrefetching
{
    // DataSourceType 的要求
    var model: Model?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}
