//
//  FindEmoticon.swift
//  表情的显示
//
//  Created by  GAIA on 2018/11/23.
//  Copyright © 2018年  GAIA. All rights reserved.

import UIKit

class FindEmoticon: NSObject {
    static let shareInstance : FindEmoticon = FindEmoticon()
    private lazy var manager : EmotionManager = EmotionManager()
    func findAttrString(statusText: String?, textFont: UIFont) -> NSMutableAttributedString?{
        //0.去空处理
        guard let statusText = statusText else {
            return nil
        }
        //1.创建匹配规则
        let pattern = "\\[.*?\\]"   //匹配表情
        //2.创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else{
            return nil
        }
        //3.开始匹配
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        //4.获取结果
        var attrMStr = NSMutableAttributedString(string: statusText)
        
        for i in stride(from: results.count - 1,through : 0 , by: -1){
            let result = results[i]
            //4.1获取chs
            let chs = (statusText as NSString).substring(with: result.range)
            //4.2 根据chs，获取图片路径
            guard let pngPath = findPngPath(chs: chs)else {
                return nil
            }
            //4.3创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: textFont.lineHeight, height: textFont.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            //4.4将属性字符串替换到来源的文字位置
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }
        return attrMStr
    }
    private func findPngPath(chs: String) -> String?{
        for package in manager.packages{
            for emoticon in package.emoticons{
                if emoticon.chs == chs{
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
