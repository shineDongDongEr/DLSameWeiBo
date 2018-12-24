//
//  EmojViewController.swift
//  表情键盘demo
//
//  Created by  GAIA on 2018/10/9.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit
private let emoCellId = "emoCellId"

class EmojViewController: UIViewController {
    //MARK:- lazyLoading
   private lazy var toolBar : UIToolbar = UIToolbar()
    

    private lazy var emoManager : EmotionManager = EmotionManager()
    
   private lazy var collectionView : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: EmojLayout())
    
    //MARK:- 定义属性
    var emoticonCallBack : (_ emoticon : Emoticon) -> ()
    
    //MARK:- 自定义构造函数(逆向传值)
    init(emoticonCallBack : @escaping (_ emoticon : Emoticon) -> ()) {
        self.emoticonCallBack = emoticonCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

//MARK:- 设置UI界面内容
extension EmojViewController{
    private func setupUI(){
        
        //1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.purple
        toolBar.backgroundColor = UIColor.lightGray
        
        //2.设置子控件的frame（VFL布局）
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar , "cView" : collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft , .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        //3.设置collectionview的布局
        prepareForCollectionView()
        
        //4.设置toolBar的布局
        prepareToolBarView()

        
        
    }
    
    private func prepareForCollectionView(){
        collectionView.register(EmojiViewCell.self, forCellWithReuseIdentifier: emoCellId)
        //将collectionView和Vc联系起来
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    private func prepareToolBarView(){
        //1.定义toolBar中的titles
        let titles = ["最近","默认","emoji","浪小花"]
        //2.遍历标题，创建item
        var index = 0
        var items = [UIBarButtonItem]()
        for title in titles{
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(EmojViewController.itemClick(item:)))
            item.tag = index
            index += 1
            items.append(item)
            //添加空格弹簧item
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            items.append(flexibleItem)
        }
        items.removeLast()
        toolBar.tintColor = UIColor.orange
        toolBar.items = items
        
    }
    @objc private func itemClick(item : UIBarButtonItem){
        print(item.tag)
        //1.获取点击的item的tag
        let tag = item.tag
        //2.根据tag获取到当前组
//        let indexPath : NSIndexPath = NSIndexPath.init(item: 0, section: tag)
        let indexPath = IndexPath(item: 0, section: tag)
        //3.滚动到对应的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

}

//MARK:- 事件监听
extension EmojViewController{
    


}

//MARK:- UICollectionViewDataSource
extension EmojViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return emoManager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = emoManager.packages[section]
        return package.emoticons.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoCellId, for: indexPath) as! EmojiViewCell
        
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.blue
        let package = emoManager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //1.取出点击的表情
        let package = emoManager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        //2.把取出的表情model插入到最近表情空白列表中
        insertRecentlyEmoticon(emoticon: emoticon)
        //3.闭包回调emoticon表情模型
        emoticonCallBack(emoticon)
        
    }
    private func insertRecentlyEmoticon(emoticon : Emoticon){
        //1.如果是空白表情或者删除按钮，不需要插入
        if emoticon.isRemove || emoticon.isRecently{
            return
        }
        //2.删除重复表情或者空格表情
        if (emoManager.packages.first!.emoticons.contains(emoticon))
        {
            //原来有该表情
            let index = emoManager.packages.first?.emoticons.index(of: emoticon)!
            emoManager.packages.first?.emoticons.remove(at: index!)
            
        }else
        {
            //原来没有这个表情
            emoManager.packages.first?.emoticons.remove(at: 19)
        }
        //3.将emoticon插入最近分组中
        emoManager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}



//MARK:- 自定义布局
class EmojLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //1.计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        
        //2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        //3.设置collectionView 的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = true
        
        //4.调整垂直间距
        let margin = (collectionView!.bounds.size.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsetsMake(margin, 0, margin, 0)
        
        
    }
}


