//
//  EmojiCell.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/24.
//

import UIKit

class EmojiCell: UITableViewCell {
    override func configure(_ model: Any?) {
        guard let emoji = model as? Emoji else { return }
        textLabel?.text = "\(emoji.emoji): \(emoji.name)"
    }
}
