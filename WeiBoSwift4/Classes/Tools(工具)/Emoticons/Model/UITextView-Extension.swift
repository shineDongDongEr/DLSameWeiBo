//
//  UITextView-Extension.swift
//  表情键盘demo
//
//  Created by  GAIA on 2018/10/23.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

extension UITextView{
    //MARK:- 插入表情字符串 
    func insertEmoticonString(emoticon : Emoticon){
        //1.处理空白表情
        if emoticon.isRecently{
            return
        }
        //2.删除按钮
        if emoticon.isRemove{
            deleteBackward()
            return
        }
        //3.emoji表情插入
        if emoticon.emojiCode != nil{
            
            let textRange = selectedTextRange!
            
            replace(textRange, withText: emoticon.emojiCode!)
            return
        }
        
        //4.普通表情（涉及到图文混排）
        //4.1根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font
        attachment.bounds = CGRect(x: 0, y: 0, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        let attrImageStr = NSAttributedString(attachment: attachment)
        //4.2 创建可变属性字符串，并替换路径属性字符串
        let attrMstr = NSMutableAttributedString(attributedString: (attributedText)!)
        let range = selectedRange
        attrMstr.replaceCharacters(in: range, with: attrImageStr)
        //4.3显示属性字符串
        attributedText = attrMstr
        //4.4将文字的大小重置
        self.font = font
        //4.5将光标设置回原来位置 + 1
       selectedRange = NSRange(location: range.location + 1 , length: 0)
    }
    //MARK:- 获取属性字符串
    func getAttributeString() -> (NSMutableAttributedString)
    {
        //1.获取属性字符串
        let attMstr = NSMutableAttributedString(attributedString:attributedText)
        //2.遍历属性字符串，替换
        let range = NSRange(location: 0, length: attMstr.length)
        attMstr.enumerateAttributes(in: range, options: [])
        { (dict , range, _) in
            if let attachment = dict[NSAttributedStringKey.attachment] as? EmoticonAttachment
            {
                attMstr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return attMstr
    }
}
