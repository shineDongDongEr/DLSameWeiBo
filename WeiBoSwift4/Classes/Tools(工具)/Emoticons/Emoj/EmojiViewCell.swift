//
//  EmojiViewCell.swift
//  表情键盘demo
//
//  Created by  GAIA on 2018/10/12.
//  Copyright © 2018年  GAIA. All rights reserved.

import UIKit

class EmojiViewCell: UICollectionViewCell {
    //MARK:- 自定义属性
    var emoticon : Emoticon?{
        didSet{
            guard let emoticon = emoticon else{return}
            //1.设置emoticonBtn的内容
            emojiBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emojiBtn.setTitle(emoticon.emojiCode, for: .normal)
            if emoticon.isRemove
            {
                emojiBtn.setImage(UIImage(named: "detelt"), for: .normal)
            }
            if emoticon.isRecently
            {
                emojiBtn.setImage(UIImage(named: ""), for: .normal)
            }
        
        }
    }
    //MARK:- lazyLoading
    private lazy var emojiBtn : UIButton = UIButton()
    
    //MARK:- 自定义构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiViewCell{
    func setupUI() {
        //1.添加子控件
        contentView.addSubview(emojiBtn)
        //2.设置frame
        emojiBtn.frame = contentView.bounds
        //3.设置btn属性
        emojiBtn.isUserInteractionEnabled = false
        
    }
}
