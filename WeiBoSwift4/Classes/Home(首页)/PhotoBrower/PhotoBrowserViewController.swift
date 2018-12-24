//
//  PhotoBrowserViewController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/12/3.
//  Copyright © 2018年  GAIA. All rights reserved.

import UIKit
import SnapKit
import SDWebImage
import SVProgressHUD

private let cellId = "cell"

class PhotoBrowserViewController: UIViewController
{
    private var picUrls : [NSURL]
    private var indexPath : NSIndexPath
    
    // MAKR: - 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserLayout())
    private lazy var closeBtn : UIButton = UIButton(backColor: UIColor.darkGray, textFont: 15, title: "关 闭")
    private lazy var saveBtn : UIButton = UIButton(backColor: UIColor.darkGray, textFont: 15, title: "保 存")

//MARK:- 自定义构造函数
    init(picUrls : [NSURL] , indexPath : NSIndexPath)
    {
        self.picUrls = picUrls
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
//MARK:- 系统回调函数
    override func loadView() {
        super.loadView()
        view.bounds.size.width += 20
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        //1.设置UI界面
        setupUI()
        //2.添加点击事件
        addClick()
        //3.滚动到相应的位置
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
}

// MAKR: - 界面设置
extension PhotoBrowserViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    func setupUI()
    {
        //1.添加到View上面
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        
        //2.SnapKit布局
        collectionView.frame = view.bounds
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90,height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
            make.size.equalTo(closeBtn.snp.size)
        }
        
        //3.注册collectionViewCell
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: cellId)
    }
    func addClick()
    {
        closeBtn.addTarget(self, action: #selector(PhotoBrowserViewController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserViewController.saveBtnClick), for: .touchUpInside)
    }
}

//MARK: -添加事件点击
extension PhotoBrowserViewController
{
    @objc func closeBtnClick()
    {
        dismiss(animated: true, completion: nil)
    }
    @objc func saveBtnClick()
    {
        //1.获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserCell
        guard let image = cell.imv.image else {
            return
        }
        //2.将对象保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func image(image : UIImage , didFinishSavingWithError error : NSError? , contextInfo : AnyObject){
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        }else {
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

// MAKR: - UICollectionViewDataSource
extension PhotoBrowserViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoBrowserCell
//        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.orange : UIColor.blue
        cell.imageUrl = picUrls[indexPath.item]
        cell.delegate = self
        return cell
    }
}

extension PhotoBrowserViewController : PhotobrowserCellDelegate{
    func imvClick() {
        closeBtnClick()
    }
}

//MARK: - 消失动画代理
extension PhotoBrowserViewController : AnimatorDismissDelegate{
    
    func imageViewForDismissView() -> UIImageView {
        //1.创建UIImageView对象
        let imageView = UIImageView()
        let cell = collectionView.visibleCells.first as! PhotoBrowserCell
        imageView.frame = cell.imv.frame
        imageView.image = cell.imv.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    func indexPathForDismissView() -> NSIndexPath {
        let cell = collectionView.visibleCells.first!
        let indexPath = collectionView.indexPath(for: cell)!
        return indexPath as NSIndexPath
    }
}

// MAKR: - 自定义布局
class PhotoBrowserLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
