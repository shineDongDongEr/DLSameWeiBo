//
//  HomeViewController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/7/11.
//  Copyright © 2018年  GAIA. All rights reserved.

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    //MARK:- lazyLoading
    private lazy var titleBtn = NavTitleBtn()
    //tipLabel
    private lazy var tipLabel = UILabel()
    
    private lazy var photoBrowAnimater : PhotoBrowAnimater = PhotoBrowAnimater()
    
    //使用self的两个地方：1.有歧义的时候；2.闭包中使用当前对象的属性和方法的时候也需要用到self
    private lazy var poperAnimator = PopoverAnimator { [weak self](presented) in
        self?.titleBtn.isSelected = presented
    }
    
    
    private lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
        
    //MARK:- life
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置转盘动画
        visitorView.setRotationAnimate()
        guard (isLogin == true) else {
            return
        }
        //设置导航栏
        setNavBtnItem()

        //3.cell高度自适应
        // tableView.rowHeight = UITableViewAutomaticDimension
        
        //设置估算高度
        tableView.estimatedRowHeight = 200
        
        //4.添加上拉刷新控件
        setupHeaderView()
        
        //5.添加下拉刷新控件
        setupFooterView()
        
        //6.设置提示的label
        setupTipLabel()
        
    }
}

//MARK:- 设置UI
extension HomeViewController{
        //设置导航栏
        func setNavBtnItem() {
        //设置左边item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_friendattention")
        //设置titleView
        titleBtn.setTitle("shineDongEr", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
        //设置右侧item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_pop")
        //添加通知
        addNotification()
    }
      //添加上拉刷新控件
    func setupHeaderView(){
         let header  = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewData))
         header?.setTitle("下拉刷新", for: .idle)
         header?.setTitle("释放立即刷新", for: .pulling)
         header?.setTitle("加载中...", for: .refreshing)
        
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    
    //添加下拉加载
    func setupFooterView(){
        let footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadOldData))
        tableView.mj_footer = footer
        
    }
    //设置tipLabel
    func setupTipLabel() {
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.textAlignment = NSTextAlignment.center
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 30)
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        tipLabel.isHidden = true
    }
    //监听通知
    private func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.collectionCellClick(note:)), name: NSNotification.Name(rawValue: ClickCellPictureNote), object: nil)
    }
}

//MARK:- 事件监听
extension HomeViewController{
    
    @objc private func loadNewData(){
        loadStatus(isNewData: true)
    }
    
    @objc private func loadOldData(){
        loadStatus(isNewData: false)
    }
    @objc private func collectionCellClick(note : NSNotification)
    {
        print(note.userInfo ?? "")
        
        let indexPath = note.userInfo![ShowPhotoIndexPathKey] as! NSIndexPath
        let picUrls = note.userInfo![ShowPhotoUserInfoKey] as! [NSURL]
        let photoBrowVc = PhotoBrowserViewController(picUrls: picUrls, indexPath: indexPath)
        
        //设置collectionView为animater的代理
        let collectionView = note.object as! PictureCollectionView
        photoBrowAnimater.delegate = collectionView
        photoBrowAnimater.dismissDelegate = photoBrowVc
        photoBrowAnimater.indexPath = indexPath
        
        
        photoBrowVc.modalPresentationStyle = .custom
        photoBrowVc.transitioningDelegate = photoBrowAnimater
        
        
        
        present(photoBrowVc, animated: true, completion: nil)
    }
    
    @objc private func titleClick(titleBtn : NavTitleBtn){
        //1.改变按钮状态
        titleBtn.isSelected = !titleBtn.isSelected
        //2.创建一个vc
        let vc = PopViewController()
        //3.设置modal样式为custom，可以保证弹出后，底下的vc上的控件不被移除
        vc.modalPresentationStyle = .custom
        poperAnimator.presentFrame = CGRect(x: UIScreen.main.bounds.size.width * 0.5 - 90, y: 55, width: 180, height: 250)
        //4.设置转场代理
        vc.transitioningDelegate = poperAnimator
        //弹出来一个vc
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
}

//MARK:- 请求数据
extension HomeViewController{
    private func loadStatus(isNewData : Bool){
        //1.获取since_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        }else
        {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : max_id - 1
        }
        //2.请求数据
        DLNetworkingTools.shareInstance.loadStatusMsg(since_id : since_id , max_id : max_id , accessToken: (UserAccountTool.shareInstance.account?.access_token)!) { (result, error) in
            //2.1错误校验
            if error != nil {
                print(error!)
                return
            }
            //2.2获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            //2.3遍历微博对应的字典
            var tempNewModelArray = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempNewModelArray.append(viewModel)
            }
            //2.4将最新请求到的数据和老数据重新排序处理
            if isNewData{
                self.viewModels = tempNewModelArray + self.viewModels
            }else
            {
                self.viewModels += tempNewModelArray
            }
            //2.4缓存图片
            self.cacheImages(viewModels: tempNewModelArray)
            
        }
    }
    //缓存图片
    private func cacheImages(viewModels : [StatusViewModel])
    {
        //1.创建group
        let group = DispatchGroup()
            for viewModel in viewModels
            {
                for picUrl in viewModel.picURLs
                {
                    //2.将该任务添加到组队列中执行
                    group.enter()
                    SDWebImageDownloader.shared().downloadImage(with: picUrl as URL, options: [], progress: nil, completed:
                        { (image, _, _, _) in
                            print("下载了一张图片")
                            group.leave()
                    })
                }
            }
        //刷新表格
        group.notify(queue: .main) {
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            print("刷新表格")
            
            //tipLabel显示
            tipLabelComeout(count: viewModels.count)
            
        }
        func tipLabelComeout(count : Int){
            //1.设置tipLabel的属性
            tipLabel.isHidden = false
            tipLabel.text = count == 0 ? "没有新数据" : "\(count)条新微博"
            //2.执行动画
            UIView.animate(withDuration: 1.0, animations: {
                self.tipLabel.frame.origin.y = 44
                
            }) { (_) in
                UIView.animateKeyframes(withDuration: 1.0, delay: 1.5, options: [], animations: {
                    self.tipLabel.frame.origin.y = 10
                }, completion: { (_) in
                    self.tipLabel.isHidden = true
                })
            }
        }
    }
}

//MARK:- tableViewDataSource

extension HomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeViewCell
        //2.赋值cell
        cell.viewModel = viewModels[indexPath.row]
        //3.返回cell
        return cell
    }
}

//MARK:- tableViewDelegate
extension HomeViewController{

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight
    }
    
   override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}



