//
//  PhotoBrowserCell.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/12/4.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotobrowserCellDelegate : NSObjectProtocol {
    func imvClick()
}

class PhotoBrowserCell: UICollectionViewCell {
    //MARK:- 自定义属性
    var imageUrl : NSURL? {
        didSet{
            //设置图片
            setContentView(imageUrl: imageUrl)
        }
    }
    
    var delegate : PhotobrowserCellDelegate?
    
    //MARK:- 懒加载属性
    private lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imv : UIImageView = UIImageView()
    private lazy var progressView = ProgressView()

    
    //MARK:- 系统回调函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}

//MARK:- 界面设置
extension PhotoBrowserCell{
      func setupUI(){
        //1.添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imv)
        
        //2.设置子控件frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        imv.frame = scrollView.bounds
        
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: ScreenW * 0.5 , y: ScreenH * 0.5)
        //3.设置控件的属性
        progressView.backgroundColor = UIColor.clear
        progressView.isHidden = true
        //4.监听图片的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserCell.imvClick))
        imv.isUserInteractionEnabled = true
        imv.addGestureRecognizer(tapGes)
      }
    
    func setContentView(imageUrl : NSURL?) {
        //1.校验nil值
        guard let imageUrl = imageUrl else{
            return
        }
        print(imageUrl)
        
        //2.取出image对象
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: imageUrl.absoluteString)
        //3.计算imv的frame
        let width = ScreenW
        let height = width / (image?.size.width)! * (image?.size.height)!
        let y : CGFloat = (height > ScreenH) ? 0 : (ScreenH - height) * 0.5
        scrollView.contentSize = CGSize(width: ScreenW, height: height)
        imv.frame = CGRect(x: 0, y: y, width: width, height: height)
        //4.设置imv的图片
        progressView.isHidden = false
        imv.sd_setImage(with: getBigUrl(smallURL: imageUrl) as URL, placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, _, _ , _) in
            self.progressView.isHidden = true
        }
    }
    private func getBigUrl(smallURL: NSURL) -> NSURL{

        let smallURLString = smallURL.absoluteString

        let bigURLString = smallURLString?.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return NSURL(string: bigURLString!)!
    }
}

//MARK: - 事件监听
extension PhotoBrowserCell{
    
    @objc private func imvClick()
    {
        delegate?.imvClick()
    }
}
