//
//  OAuthViewController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/8.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    //MARK:- life
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //1.设置导航栏
        setupNavBar()
        //2.加载网页
        loadWebPage()
        
    }

}

//MARK:- 设置UI界面相关
extension OAuthViewController{
    private func setupNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action:#selector(OAuthViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "填充", style: .plain, target: self, action:#selector(OAuthViewController.fillItemClick))
        navigationItem.title = "登录页面"
        myWebView.delegate = self
    }
    private func loadWebPage(){
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_url)"
        guard let url = NSURL.init(string:urlString) else{ return }
        let request = NSURLRequest.init(url: url as URL)
        myWebView.loadRequest(request as URLRequest)
    }
}

//MARK:- UIWebViewDelegate
extension OAuthViewController:UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    //当准备加载一个网页的时候，会执行该方法
    //返回true->继续加载该页面， false -> 不会加载该页面
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //1.获取加载网页的NSURL
        guard let url = request.url else {
            return true
        }
        //2.获取url中的字符串
        let urlString = url.absoluteString
        //3.获取code
        guard urlString.contains("code=") else
        {
            return true
        }
        //4.获取code
        let code = urlString.components(separatedBy: "code=").last!
        //5.请求AccessToken
        loadAccessToken(code: code)
        return false
    }
}

//MARK:- 获取accessToken
extension OAuthViewController{
    //请求AccessToken
    private func loadAccessToken(code : String){
        DLNetworkingTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            if error != nil{
                print(error!)
                return
            }
            //拿到结果
            guard let accountDict = result else {
                print("没有获取到后台授权数据")
                return
            }
            //字典转模型
            let account = UserAccount(dict: accountDict)
            
            //请求用户信息
            self.getUserInfo(userAccount: account)
            
        }
    }
    
    //MARK:- 请求用户信息
    private func getUserInfo(userAccount : UserAccount){
        //1.校验accessToken
//        guard let accessToken = userAccount.access_token else { return }
        //2.获取uid
//        guard let uid = userAccount.uid else { return }
        
        //2.5由于提交到微博开放平台的应用未通过审核,暂时只能用测试的accessToken "2.00z1QHBGYBFQFB90b9acc26d0ez7qV"和测试昵称"1040820703vtEan"
        let screen_name = "1040820703vtEan"
        let accessToken = "2.00z1QHBGYBFQFB90b9acc26d0ez7qV"
        
        //3.发送网络请求
        DLNetworkingTools.shareInstance.getUserAccount(access_token: accessToken, screen_name: screen_name) { (result, error ) in
            //1.错误验证
            if error != nil{
                print(error!)
                return
            }
            //2.拿到用户信息的结果
            guard let userInfoDict = result else { return }
            
            //3.从字典中取出昵称和用户头像地址
            userAccount.screen_name = userInfoDict["screen_name"] as? String
            userAccount.avatar_hd = userInfoDict["avatar_hd"] as? String
            //4.将account对象保存
            print(userAccount)
            //4.1获取沙河路径
//            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
//
//            print(accountPath)
            //4.2 保存对象
            NSKeyedArchiver.archiveRootObject(userAccount, toFile: UserAccountTool.shareInstance.accountPath)
            //4.3 将account对象设置到单例中
            UserAccountTool.shareInstance.account = userAccount
            
            //5.退出当前控制器
            self.dismiss(animated: false, completion: {
                //6.显示欢迎界面
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
            
        }
    }
}

//MARK:- 事件监听函数
extension OAuthViewController{
    //关闭页面
    @objc private func closeItemClick(){
        dismiss(animated: true, completion: nil)
    }
    //填充账号密码-执行JS代码
    @objc private func fillItemClick(){
        //1.书写js代码
        let jsCode = "document.getElementById('userId').value='542155086@qq.com';document.getElementById('passwd').value='LAIdongling1114';"
        //2.执行js代码
        myWebView.stringByEvaluatingJavaScript(from: jsCode)
    }
}


