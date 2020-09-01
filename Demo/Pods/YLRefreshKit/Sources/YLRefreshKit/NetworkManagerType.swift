//
//  NetworkManagerType.swift
//  YLRefreshKit-Test
//
//  Created by 玉垒浮云 on 2020/8/30.
//

import YLExtensions

public protocol NetworkManagerType {
    associatedtype Scene: SceneType
    associatedtype Model: ModelType
    associatedtype E: Error
    associatedtype R
    
    @discardableResult
    func request(target: Scene, completion: @escaping (Result<Model, E>) -> Void) -> R
}
