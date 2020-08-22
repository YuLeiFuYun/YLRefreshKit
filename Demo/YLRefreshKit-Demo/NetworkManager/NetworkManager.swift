//
//  NetworkManager.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import Foundation

enum Target {
    case first(page: Int)
    case second(page: Int)
}

struct NetworkManager {
    func request<T>(target: Target, completion: @escaping (Result<T, Error>) -> Void) {
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
            
            print("completion")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("success")
                completion(.success(emojiModel as! T))
            }
        case .second(let page):
            let start = 30 * (page - 1)
            let end = 30 * page
            let numbers = Array(start..<end)
            let nextPage = (page > 3) ? nil : page + 1
            let numberModel = NumberModel(numbers: numbers, nextPage: nextPage)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(numberModel as! T))
            }
        }
    }
}
