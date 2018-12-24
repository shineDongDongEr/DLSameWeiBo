//
//  PickPikerViewCell.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/9/30.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class PickPikerViewCell: UICollectionViewCell {
    //MARK:- 控件的属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var deletBtn: UIButton!
    @IBOutlet weak var imv: UIImageView!
    //MARK:- 自定义属性
    var image : UIImage?{
        didSet{
            if image != nil {
                imv.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                deletBtn.isHidden = false
            }else
            {
                imv.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
                deletBtn.isHidden = true
            }
        }
    }
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


//MARK:- 系统监听函数
extension PickPikerViewCell {
    
    @IBAction func addPicClick(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    
    @IBAction func  deletBtnClick(_ sender: UIButton){
        
     NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerDeletPhotoNote), object: imv.image)
    }
    
}
