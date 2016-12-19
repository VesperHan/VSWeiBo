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
        tools.requestSerializer.timeoutInterval = 5
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
        return
        //以下方式同样可以, 但是要和b包回调格式和内容保持一致
        let successCallBack = { (task : URLSessionDataTask, result : Any?) -> Void in
            finished(result, nil)
        }
        
        let failureCallBack = { (task : URLSessionDataTask?, error : Error) -> Void in
            finished(nil, error)
        }
        get(urlStr, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
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
    
    func loadStatus(_ since_id:Int,_ max_id:Int,finishd:@escaping(_ result:[[String:AnyObject]]?,_ error:Error?)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameters = ["access_token":UserAccountViewModel.shareIntance.userAccount!.access_token,
                          "since_id":"\(since_id)","max_id":"\(max_id)"]
        
        request(.Get, urlStr: urlString, parameters: parameters) { (result, error) in
       
            guard let resultDict = result as? [String :AnyObject]else{
                
                finishd(nil, error)
                return
            }
            //若有值传给外部控制器
            finishd(resultDict["statuses"] as?[[String:AnyObject]],error)
            Infolog(resultDict)
        }
    }
}

// MARK:- 发微博带照片
extension VSNetworkTools {

    func sendStatus(statusText:String,image:UIImage,isSuccess:@escaping (_ isSuccess:Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        let parameters = ["access_token":(UserAccountViewModel.shareIntance.userAccount?.access_token),
                          "status":statusText]
        
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
            if let imageData = UIImageJPEGRepresentation(image, 0.5){
            
                    formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
        }, progress: nil, success: { (_, _) in
            
            isSuccess(true)
        }, failure: { (_, error) in
            
            Errolog(error)
        })
    }
}

// MARK:- 发微博不带照片
extension VSNetworkTools {

    func sendStatus(statusText:String,isSuccess:@escaping(_ isSuccess:Bool)->()){
    
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        let parameters = ["access_token":(UserAccountViewModel.shareIntance.userAccount?.access_token),
                          "status":statusText]
        Infolog(parameters)
        request(.Post, urlStr: urlString, parameters: parameters){ (result,error) in
        
            if result != nil {
            
                isSuccess(true)
            }else{
                
                isSuccess(false)
            }
        }
    }
}
