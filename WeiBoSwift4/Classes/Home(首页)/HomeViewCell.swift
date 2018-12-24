//
//  HomeViewCell.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/9/4.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15.0
private let picMargin : CGFloat = 10.0

class HomeViewCell: UITableViewCell {

    //MARK:- 控件属性
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var verifiedView: UIImageView!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var vipView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    //底部工具栏 
    @IBOutlet weak var bottomeToolView: UIView!
    @IBOutlet weak var contentLabel: HYLabel!
    //转发文字
    @IBOutlet weak var retweetedLabel: HYLabel!
    //转发背景图
    @IBOutlet weak var retweetedBackView: UIView!
    //MARK:- 约束的属性
    //图片的宽高约束 
    @IBOutlet weak var picViewWcns: NSLayoutConstraint!
    
    @IBOutlet weak var picViewHcns: NSLayoutConstraint!
    
    @IBOutlet weak var myCollectionView: PictureCollectionView!
    //转发正文距离顶部约束
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewWns: NSLayoutConstraint!
    //MARK:- 自定义属性
    var viewModel : StatusViewModel?{
        didSet{
            //1.nil 值校验
            guard let viewModel = viewModel else {
                return
            }
            //2.设置头像
            iconView.sd_setImage(with: viewModel.profileURL! as URL, completed: nil)
            //3.设置认证图标
            verifiedView.image = viewModel.verifiedImage
            //4.处理昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            //5.会员图标
            vipView.image = viewModel.vipImage
            //6.时间
            timeLabel.text = viewModel.createAtText
            //7.设置微博正文
            contentLabel.attributedText = FindEmoticon.shareInstance.findAttrString(statusText: viewModel.status?.text, textFont: contentLabel.font)
            //7.1设置来源
            if let sourceText = viewModel.sourceText{
                sourceLabel.text = "来自" + sourceText
            }else
            {
                sourceLabel.text = nil
            }
            //8.设置昵称的 文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            //9.根据图片张数确认占位图片尺寸
            let picSize = getPicSizeWithPictureCount(picCount: viewModel.picURLs.count)
            picViewWcns.constant = picSize.width
            picViewHcns.constant = picSize.height
            //10.将picUrl数据传递给picView
            myCollectionView.picUrls = viewModel.picURLs
            //1.设置转发微博正文
            if viewModel.status?.retweeted_status?.text != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,
                   let  retweetedText = viewModel.status?.retweeted_status?.text{
//                    retweetedLabel.text = "@" + " \(screenName): " + retweetedText
                    let retweetedText = "@" + " \(screenName): " + retweetedText
                    retweetedLabel.attributedText = FindEmoticon.shareInstance.findAttrString(statusText: retweetedText, textFont: retweetedLabel.font)
                     //设置转发正文距离顶部的约束
                    retweetedContentLabelTopCons.constant = 15
                }
                   //2.设置背景显示
                    retweetedBackView.isHidden = false
                
            }else{
                    //设置转发微博的正文
                    retweetedLabel.text = nil
                    //设置背景显示
                    retweetedBackView.isHidden = true
                    //设置转发正文距离顶部的约束
                    retweetedContentLabelTopCons.constant = 0
            }
            //12.设置cell的高度
            //12.2获取底部工具栏的最大Y值
            if viewModel.cellHeight == 0
            {
                //强制布局
                layoutIfNeeded()
                viewModel.cellHeight = bottomeToolView.frame.maxY
            }
        }
    }
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置微博正文的宽度约束
        contentViewWns.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        
        //1.取出layout
        let layout = myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //2.计算出来imageViewWH
        let picWH = (UIScreen.main.bounds.width - edgeMargin * 2  - 2 * picMargin) / 3
        //3.赋值itemSize
        layout.itemSize = CGSize(width: picWH, height: picWH)
        //4.设置颜色
        contentLabel.matchTextColor = UIColor.purple
        retweetedLabel.matchTextColor = UIColor.blue
        //5.监听点击
        //监听@谁谁谁的点击
        contentLabel.userTapHandler = {(label, user, range) in
            print(user,range)
        }
        //监听链接的点击
        contentLabel.linkTapHandler = {(label, link, range) in
            print(link,range)
        }
        //监听话题的点击
        contentLabel.topicTapHandler = {(label, topic, range) in
            print(topic,range)
        }
    }
}

//MARK:- 根据图片张数确认占位图片尺寸
extension HomeViewCell{
   private func getPicSizeWithPictureCount(picCount : Int) -> CGSize {
        //1.没有配图
        if picCount == 0 {
            
            return CGSize.zero
        }
        //2.计算出来imageViewWH
        let picWH = (UIScreen.main.bounds.width - edgeMargin * 2  - 2 * picMargin) / 3
        //2.1单张配图(实际开发中，美工会告知单张图片的尺寸)
        if picCount == 1
        {
//            let urlString = viewModel?.picURLs.first?.absoluteString
//            let image = SDImageCache.shared().imageFromDiskCache(forKey: urlString)
//            return image != nil ? CGSize(width: ((image?.size.width)! * 2), height: ((image?.size.height)!) * 2): CGSize(width: picWH, height: picWH)
            
            return CGSize(width: picWH, height: picWH)
        }
    
        //3.四张配图
        if picCount == 4 {
            let picViewWH = picWH * 2 + picMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
    
        //4.计算其他图
        //4.1计算行数
        let rows = CGFloat((picCount - 1) / 3 + 1)
    
        //4.2 计算picView的高度
        let picViewH = rows * picWH + (rows - 1) * picMargin
    
        //4.3 计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
    
        return CGSize(width: picViewW, height: picViewH)
    }
 }











