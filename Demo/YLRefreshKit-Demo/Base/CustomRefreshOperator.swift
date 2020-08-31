//
//  CustomRefreshOperator.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/31.
//

import YLRefreshKit

// 如果你需要进行错误处理或在刷新前后进行一些操作，请创建一个继承自 RefreshOperator 的子类并重写你需要的方法
class CustomRefreshOperator<DS: DataSourceType, NM: NetworkManagerType>: RefreshOperator<DS, NM> where DS.Model == NM.Model {
    override func startTransition(_ state: RefreshState) {
        print("startTransition")
    }
    
    override func endTransition(_ state: RefreshState) {
        print("endTransition")
    }
    
    override func errorHandling(_ error: Error) -> RefreshState {
        // 错误处理
        print("errorHandling")
        return .error(error)
    }
}
