//
//  FirstViewModel.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import UIKit

class FirstViewModel: TViewModel<EmojiModel> {
    override var model: EmojiModel? {
        didSet {
            guard let model = model else { return }
            
            if oldValue == nil {
                // 刷新
                emojis = model.emojis
            } else {
                // 加载更多
                emojis += model.emojis
            }
        }
    }
    
    var emojis: [Emoji] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 由于知道 tableView 仅有一类自带的 cell，所以可以这么写
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        let emoji = emojis[indexPath.row]
        cell.textLabel?.text = "\(emoji.emoji): \(emoji.name)"
        
        return cell
    }
}
