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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model == nil ? 0 : model!.data!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model == nil ? 0 : model!.data![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: Model.tAll!)
        cell.configure(model!.data![indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}
