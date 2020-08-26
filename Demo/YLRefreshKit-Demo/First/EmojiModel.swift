//
//  EmojiModel.swift
//  YLRefreshKit-Demo
//
//  Created by 玉垒浮云 on 2020/8/22.
//

import UIKit
import YLExtensions

struct Emoji {
    let name: String
    let emoji: String
}

struct EmojiModel: ModelType {
    let emojis: [Emoji]
    let nextPage: Int?
    var data: [[Any]]?
    
    init(emojis: [Emoji], nextPage: Int?) {
        self.emojis = emojis
        self.nextPage = nextPage
        data = [emojis]
    }
}

extension EmojiModel {
    static var tCells: [UITableViewCell.Type]? {
        [EmojiCell.self]
    }
    
    static var tAll: [UITableViewCell.Type]? {
        [EmojiCell.self]
    }
}

let eEmojis = [["😀", "Grinning Face"], ["😃", "Grinning Face with Big Eyes"], ["😄", "Grinning Face with Smiling Eyes"], ["😁", "Beaming Face with Smiling Eyes"], ["😆", "Grinning Squinting Face"], ["😅", "Grinning Face with Sweat"], ["🤣", "Rolling on the Floor Laughing"], ["😂", "Face with Tears of Joy"], ["🙂", "Slightly Smiling Face"], ["🙃", "Upside-Down Face"], ["😉", "Winking Face"], ["😊", "Smiling Face with Smiling Eyes"], ["😇", "Smiling Face with Halo"], ["🥰", "Smiling Face with Hearts"], ["😍", "Smiling Face with Heart-Eyes"], ["🤩", "Star-Struck"], ["😘", "Face Blowing a Kiss"], ["😗", "Kissing Face"], ["☺", "Smiling Face"], ["😚", "Kissing Face with Closed Eyes"], ["😙", "Kissing Face with Smiling Eyes"], ["😋", "Face Savoring Food"], ["😛", "Face with Tongue"], ["😜", "Winking Face with Tongue"], ["🤪", "Zany Face"], ["😝", "Squinting Face with Tongue"], ["🤑", "Money-Mouth Face"], ["🤗", "Hugging Face"], ["🤭", "Face with Hand Over Mouth"], ["🤫", "Shushing Face"], ["🤔", "Thinking Face"], ["🤐", "Zipper-Mouth Face"], ["🤨", "Face with Raised Eyebrow"], ["😐", "Neutral Face"], ["😑", "Expressionless Face"], ["😶", "Face Without Mouth"], ["😏", "Smirking Face"], ["😒", "Unamused Face"], ["🙄", "Face with Rolling Eyes"], ["😬", "Grimacing Face"], ["🤥", "Lying Face"], ["😌", "Relieved Face"], ["😔", "Pensive Face"], ["😪", "Sleepy Face"], ["🤤", "Drooling Face"], ["😴", "Sleeping Face"], ["😷", "Face with Medical Mask"], ["🤒", "Face with Thermometer"], ["🤕", "Face with Head-Bandage"], ["🤢", "Nauseated Face"], ["🤮", "Face Vomiting"], ["🤧", "Sneezing Face"], ["🥵", "Hot Face"], ["🥶", "Cold Face"], ["🥴", "Woozy Face"], ["😵", "Dizzy Face"], ["🤯", "Exploding Head"], ["🤠", "Cowboy Hat Face"], ["🥳", "Partying Face"], ["😎", "Smiling Face with Sunglasses"], ["🤓", "Nerd Face"], ["🧐", "Face with Monocle"], ["😕", "Confused Face"], ["😟", "Worried Face"], ["🙁", "Slightly Frowning Face"], ["☹", "Frowning Face"], ["😮", "Face with Open Mouth"], ["😯", "Hushed Face"], ["😲", "Astonished Face"], ["😳", "Flushed Face"], ["🥺", "Pleading Face"], ["😦", "Frowning Face with Open Mouth"], ["😧", "Anguished Face"], ["😨", "Fearful Face"], ["😰", "Anxious Face with Sweat"], ["😥", "Sad but Relieved Face"], ["😢", "Crying Face"], ["😭", "Loudly Crying Face"], ["😱", "Face Screaming in Fear"], ["😖", "Confounded Face"], ["😣", "Persevering Face"], ["😞", "Disappointed Face"], ["😓", "Downcast Face with Sweat"], ["😩", "Weary Face"], ["😫", "Tired Face"], ["🥱", "Yawning Face"], ["😤", "Face with Steam From Nose"], ["😡", "Pouting Face"], ["😠", "Angry Face"], ["🤬", "Face with Symbols on Mouth"], ["😈", "Smiling Face with Horns"], ["👿", "Angry Face with Horns"], ["💀", "Skull"], ["☠", "Skull and Crossbones"]]
