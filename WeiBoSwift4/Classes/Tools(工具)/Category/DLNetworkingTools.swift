//
//  DLNetworkingTools.swift
//  DLSwiftDemo
//
//  Created by winter on 2018/8/5.
//  Copyright © 2018年 laidongling. All rights reserved.
//

import AFNetworking

enum RequestType : String
{
    case GET = "GET"
    case POST = "POST"
}

class DLNetworkingTools: AFHTTPSessionManager
{
    //let是线程安全的
    static let shareInstance : DLNetworkingTools = {
        let tools = DLNetworkingTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")

        return tools
    }()
}

//MARK: - 请求首页数据
extension DLNetworkingTools{
    func loadStatusMsg(since_id : Int , max_id : Int , accessToken : String , finished : @escaping (_ result : [[String : AnyObject]]? ,_ error : NSError? ) -> ()){
        //1.获取url
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        //2.获取请求参数
        let parameters = ["access_token" : accessToken , "since_id" : "\(since_id)" , "max_id" : "\(max_id)" , "count" : "\(10)"]
        //3.发起请求
        request(requestType: .GET, urlString: url, parameters: parameters as [String : AnyObject]) { (result, error) in
            //a.获取字典数据
            guard let resultDict = result as? [String : AnyObject] else{
                finished(nil, error)
                return
            }
            //b.将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : AnyObject]], error)
        }
    }
}

//MARK: - 获取accessToken
extension DLNetworkingTools{
    func loadAccessToken(code : String , finished : @escaping (_ result : [String : AnyObject]? ,_ error : NSError?) -> ()){
        //1.获取url
        let url = "https://api.weibo.com/oauth2/access_token"
        //2.获取请求的参数
        let parameters = ["client_id" : app_key , "client_secret" : app_secret , "grant_type" : "authorization_code" , "redirect_uri" : redirect_url , "code" : code]
        //3.发起请求
        request(requestType: .POST, urlString: url, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as? [String : AnyObject] , error)
        }
    }
}

//MARK: - 获取用户信息
//测试accessToken:2.00z1QHBGYBFQFB90b9acc26d0ez7qV
extension DLNetworkingTools{
    func getUserAccount(access_token : String , screen_name : String , finished : @escaping (_ result : [String : AnyObject]? , _ error : NSError?) -> ()) {
        //1.获取url
        let url = "https://api.weibo.com/2/users/show.json"
        //2.拼接参数
        let parameters = ["access_token":access_token , "screen_name":screen_name]
        //3.发送请求
        request(requestType: .GET, urlString: url, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as? [String : AnyObject], error)
        }
    }
}


// MARK: - 封装请求方法
extension DLNetworkingTools{
    func request(requestType : RequestType, urlString : String , parameters : [String : AnyObject] , finished : @escaping (_ result : AnyObject? , _ error : NSError?) -> ()) {
        //1.定义成功的闭包
        let successBlock =  { (task : URLSessionDataTask , result : Any?) in
            finished(result as AnyObject,nil)
        }
        //2.定义失败的闭包
        let failBlock = { (task : URLSessionDataTask?, error : Error) in
            finished(nil,error as NSError)
        }
        if requestType == .GET
        {
//            get(urlString, parameters: parameters, progress: nil, success: { (task : URLSessionDataTask, result : Any?) in
//                finished(result as AnyObject,nil)
//            }) {
//                (task : URLSessionDataTask?, error : Error) in
//                finished(nil,error as NSError)
//            }
            get(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failBlock)
        }else
        {
            post(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failBlock)
            
        }
    }
}

// MARK: - 发送一条微博（新接口不可用了！！！！这里就直接弹出你的微博文字）
extension DLNetworkingTools{
    func sendStatus(statusText : String, isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
        //1.获取urlString
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        //2.获取请求参数
        let parameters = ["access_token" : (UserAccountTool.shareInstance.account?.access_token)! , "status" : statusText];
        //3.发送请求
        request(requestType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            if result != nil
            {
                isSuccess(true)
                
            }else
            {
                isSuccess(false)
            }
        }
    }
}

// MARK: - 发送一条微博，并且携带图片（新接口不可用了！！！！这里直接弹出携图+Text）
extension DLNetworkingTools{
    func sendStatus(statusText : String , image : UIImage , isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
         //1.获取urlString
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
         //2.获取请求参数
        let parameters = ["access_token" : (UserAccountTool.shareInstance.account?.access_token)!, "status" : statusText]
        //3.发送网络请求
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            if let imageData = UIImageJPEGRepresentation(image, 0.5){
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
        }, progress: nil, success: { (_, _ ) in
            isSuccess(true)
        }) { (_ , error) in
            isSuccess(false)
            print(error)
        }
        
    }
}


