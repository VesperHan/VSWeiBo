//
//  VSNetworkTools.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/7.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import AFNetworking

enum RequestType : String {
    case Get = "GET"
    case Post = "POST"
}

class VSNetworkTools: AFHTTPSessionManager {

    //let是线程安全的
    //这就是单例 
    //类属性 static
    static let shareInstance : VSNetworkTools = {
    
        let tools = VSNetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}

extension VSNetworkTools {
    
    func request(_ methodType:RequestType,urlStr:String,parameters:[String:Any],finished: @escaping (_ result:Any?,_ error:Error?) -> ()){
    
        if methodType == RequestType.Get {
            
            get(urlStr, parameters: parameters, progress: nil, success: { (URLSessionDataTask, result) in

                finished(result, nil)
            }, failure: { (URLSessionDataTask, error) in
                
                finished(nil,error)
            })
            
        }else{
        
            post(urlStr, parameters: parameters, progress: nil, success: { (URLSessionDataTask, result) in
                
                finished(result,nil)
            }, failure: { (URLSessionDataTask, error) in
                
                finished(nil,error)
            })
        }
    }
}

extension VSNetworkTools {

    // MARK:- 获取Token
    func loadAccessToken(code:String,finishd:@escaping (_ result:[String:AnyObject]?,_ error:Error?)->()){

        //获取请求urlstring
        let urlString = "https://api.weibo.com/oauth2/access_token"

        //获取参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        
        request(.Post, urlStr: urlString, parameters: parameters) { (result, error) in
            
            finishd(result as? [String:AnyObject],error)
        }
    }
    
    func loadUserInfo(access_token:String,uid:String,finishd:@escaping(_ result:[String:AnyObject]?,_ error:Error?)->()) {
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["access_token":access_token,"uid":uid]
        
        request(.Get, urlStr: urlString, parameters: parameters) { (result, error) in
            
            finishd(result as? [String:AnyObject],error)
        }
    }
}

// MARK:- 请求首页数据
extension VSNetworkTools {
    
    func loadStatus(finishd:@escaping(_ result:[[String:AnyObject]]?,_ error:Error?)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameters = ["access_token":UserAccountViewModel.shareIntance.userAccount!.access_token]
        
        request(.Get, urlStr: urlString, parameters: parameters) { (result, error) in
            
            guard let resultDict = result as? [String :AnyObject]else{
                
                finishd(nil, error)
                return
            }
            //若有值传给外部控制器
            finishd(resultDict["statuses"] as?[[String:AnyObject]],error)
        }
    }
}
