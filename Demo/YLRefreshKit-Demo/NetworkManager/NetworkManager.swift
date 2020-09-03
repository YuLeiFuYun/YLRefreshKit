//
//  NetworkManager.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import YLRefreshKit
import YLExtensions

enum Target: TargetType {
    case first(page: Int)
    case second(page: Int)
    
    // 是否能进行刷新操作。注意，不是指是否遵循 Refreshable 协议
    var isRefreshable: Bool {
        return true
    }
    
    mutating func update(with action: RefreshAction, targetInfo: Any?) {
        guard isRefreshable else { return }
        
        print("targetInfo: \(String(describing: targetInfo))")
        
        switch action {
        case .pullToRefresh:
            switch self {
            case .first:
                self = .first(page: 1)
            case .second:
                self = .second(page: 1)
            }
        case .loadingMore:
            switch self {
            case .first(let page):
                self = .first(page: page + 1)
            case .second(let page):
                self = .second(page: page + 1)
            }
        }
    }
}

struct NetworkManager<Model: ModelType>: NetworkManagerType {
    func request(target: Target, completion: @escaping (Result<Model, Error>) -> Void) {
        switch target {
        case .first(let page):
            let start = 30 * (page - 1)
            let end = min(30 * page, eEmojis.count)
            
            var emojis: [Emoji] = []
            for emoji in eEmojis[start..<end] {
                let model = Emoji(name: emoji[1], emoji: emoji[0])
                emojis.append(model)
            }
            
            let nextPage = (end >= eEmojis.count) ? nil : page + 1
            let emojiModel = EmojiModel(emojis: emojis, nextPage: nextPage)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(emojiModel as! Model))
            }
        case .second(let page):
            let start = 30 * (page - 1)
            let end = 30 * page
            let numbers = Array(start..<end)
            let nextPage = (page > 3) ? nil : page + 1
            let numberModel = NumberModel(numbers: numbers, nextPage: nextPage)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(numberModel as! Model))
            }
        }
    }
}
