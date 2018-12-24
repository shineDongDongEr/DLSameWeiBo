//
//  PictureCollectionView.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/9/6.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit
import SDWebImage

class PictureCollectionView: UICollectionView {
    //MARK:- 定义可变数组属性
    var picUrls : [NSURL] = [NSURL](){
        didSet {
            self.reloadData()
        }
    }
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
    }
}

//数据源
extension PictureCollectionView : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! picCollectionViewCell
        let picURL = picUrls[indexPath.row]
        cell.picURL = picURL
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = [ShowPhotoIndexPathKey: indexPath, ShowPhotoUserInfoKey: picUrls] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:ClickCellPictureNote), object: self, userInfo: userInfo)
    }
}

class picCollectionViewCell: UICollectionViewCell {
 //MARK:- 定义模型属性
    var picURL : NSURL?{
        didSet{
            guard let picURL = picURL else{
                return
            }
            iconView.sd_setImage(with: picURL as URL, placeholderImage:  UIImage(named:"avatar_default"), options: [], progress: nil, completed: nil)
        }
    }
    //MARK:- 控件的属性
    @IBOutlet weak var iconView: UIImageView!
}

extension PictureCollectionView : AnimatorPresentedDelegate{
    
    func getStartRect(indexPath: NSIndexPath) -> CGRect {
        //1.获取cell
        let cell = self.cellForItem(at: indexPath as IndexPath)!
        //2.获取cell相对于屏幕的frame
//        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
         let startFrame = self.convert(cell.frame, to: nil)
        return startFrame
    }
    
    func getEndRect(indexPath: NSIndexPath) -> CGRect {
        //1.获取图片
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString)
        //2.获取结束后的frame
        let w = ScreenW
        let h = w / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        y = (h > ScreenH) ? 0 : (ScreenH - h)*0.5
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        //1.创建一个imv对象
        let imv = UIImageView()
        //2.获取该位置的image对象
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString)
        //3.设置imv的属性
        imv.image = image
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        
        return imv
    }
}
