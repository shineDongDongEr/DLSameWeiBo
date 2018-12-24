//
//  ComposeBtnViewController.swift
//  WeiBoSwift4
//  Created by  GAIA on 2018/9/25.
//  Copyright © 2018年  GAIA. All rights reserved.

import UIKit
import SVProgressHUD

class ComposeBtnViewController: UIViewController {
    //MARK:- 懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    private lazy var images : [UIImage] = [UIImage]()
    private lazy var emoticonVc : EmojViewController = EmojViewController {[weak self](emoticon) in
        self?.myTextView.insertEmoticonString(emoticon: emoticon)
        //手动调用change方法
        self?.textViewDidChange((self?.myTextView)!)
    }
    
    //MARK:- 约束的属性
    @IBOutlet weak var myTextView: ComposeTextView!

    @IBOutlet weak var myCollectionView: PickPictureCollectionView!
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    //选中图片弹出的collectionview的高度
    @IBOutlet weak var picCollectionHeightCns: NSLayoutConstraint!
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏
        setNavItem()
        //监听通知
        setupNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myTextView.becomeFirstResponder()
        myTextView.delegate = self
    }
    

    deinit {
              NotificationCenter.default.removeObserver(self)
           }
}

//MARK: -设置UI界面
extension ComposeBtnViewController{
    private func setNavItem()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeBtnViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeBtnViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    private func setupNotifications(){
        //监听键盘frame改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeBtnViewController.keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //监听添加照片按钮的通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeBtnViewController.addPictureClick), name:NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        //监听删除照片按钮的通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeBtnViewController.deletPhoto(note:)), name: NSNotification.Name(rawValue: PicPickerDeletPhotoNote), object: nil)
        
    }
}

//MARK: - 事件监听函数
extension ComposeBtnViewController{

    @objc private func closeItemClick(){
        
        dismiss(animated: true, completion: nil)
    }
    //MARK:- 点击了发送按钮
    @objc private func sendItemClick(){
        print(myTextView.getAttributeString().string)
        //0.键盘退出
        myTextView.resignFirstResponder()
        // MARK: - 封装请求方法
        //1.获取微博正文string
        let statusText = myTextView.getAttributeString().string
        //2.定义回调闭包
        let finishCallback = { (isSuccess : Bool) in
            if !isSuccess
            {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                SVProgressHUD.showInfo(withStatus: statusText)
                return
            }else
            {
                SVProgressHUD.showSuccess(withStatus: "发送微博成功")
                self.dismiss(animated: true, completion: nil)
            }
        }
        //3.获取用户选中图片
        if let image = images.first
        {
            DLNetworkingTools.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: finishCallback)
        }else
        {
            DLNetworkingTools.shareInstance.sendStatus(statusText: statusText, isSuccess: finishCallback)
        }
    }
    
    @objc private func keyboardWillChangeFrame(note : NSNotification){
        //1.获取动画执行的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        //2.获取键盘最终的Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        //3.计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        //4.执行动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    //MARK:- 删除照片
    @objc private func deletPhoto(note : NSNotification){
        //1.获取到image
        guard let image = note.object as? UIImage else {
            return
        }
        //2.获取下标值
        guard let index = images.index(of: image) else {
            return
        }
        //3.删除图片
        images.remove(at: index)
        
        //4.重新赋值collectionView新的数组
        myCollectionView.images = images
        
        //5.刷新collectionView
        myCollectionView.reloadData()

    }
    
    //MARK:- 添加照片
    @objc private func addPictureClick(){
        print("点击了添加照片")
        //1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        //2.创建照片控制器
        let ipc = UIImagePickerController()
        //3.设置照片源
        ipc.sourceType = .photoLibrary
        //4.设置代理
        ipc.delegate = self
        //5.弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
    }
    
    //MARK:- 点击了表情键盘btn
    @IBAction func emojClick(_ sender: UIButton) {
        //1.退出键盘
        myTextView.resignFirstResponder()
        //2.切换键盘
        myTextView.inputView = myTextView.inputView == nil ? emoticonVc.view : nil
        //3.弹出键盘
        myTextView.becomeFirstResponder()
        
    }
    
    //MARK:- 点击了添加图片按钮
    @IBAction func pictureAddBtnClick(_ sender: Any)
    {
        //先退出键盘
        myTextView.resignFirstResponder()
        picCollectionHeightCns.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
}

extension ComposeBtnViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        //1.获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //2.展示照片
        images.append(image)
        //3.赋值给collectionView,让collectionView自己去展示图片
        myCollectionView.images = images
        myCollectionView.reloadData()
        //4.退出选中照片控制器
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- UITextViewDelegate代理方法
extension ComposeBtnViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
        self.myTextView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        myTextView.resignFirstResponder()
    }
    
}


