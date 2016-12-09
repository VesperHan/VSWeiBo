//
//  OAuthViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/7.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "登陆"
        setupNav()
        
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: "https://api.weibo.com/oauth2/authorize?client_id=736061409&redirect_uri=http://www.baidu.com")!))
    }
}

extension OAuthViewController{

   fileprivate func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain,target:self, action:#selector(closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(autoSigninClick))
    }
}

extension OAuthViewController {

    @objc fileprivate func closeBtnClick(){
    
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func autoSigninClick(){
    
        let jsCode = "document.getElementById('userId').value='447636737@qq.com';document.getElementById('passwd').value='zx286011104';"
        
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

// MARK:- webview delegate
extension OAuthViewController:UIWebViewDelegate{

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard request.url != nil else {
            
            return true
        }
        
        let urlStr = request.url!.absoluteString
        //判断该字符串中是否有code
        guard urlStr.contains("code=") else {
            
            return true
        }
        
        //以code=作为分割,取出一个数组里面有两部分,code=之前 和  code=之后
        let code = urlStr.components(separatedBy: "code=").last!
        
        loadAccessToken(code: code)
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        SVProgressHUD.dismiss()
    }
}

extension OAuthViewController{

    fileprivate func loadAccessToken(code:String){
        
        VSNetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            
            // 1.错误校验
            if error != nil {
                Infolog(error!)
                return
            }
            // 2.拿到结果
            guard let accountDict = result else {
                Infolog("没有获取授权后的数据")
                return
            }
            // 3.将字典转成模型对象
            let account = UserAccount(dict: accountDict)
            
            // 4. 请求用户信息
            self.loadUserInfo(account: account)
        }
    }
    
    fileprivate func loadUserInfo(account:UserAccount){

        guard let access_token = account.access_token else{
        
            return
        }
        guard let uid = account.uid else {
            
            return
        }
        
        VSNetworkTools.shareInstance.loadUserInfo(access_token:access_token, uid: uid) { (result, error) in
            
            if error != nil{
            
                Infolog(error!)
                return
            }
            guard let result = result else{
            
                return
            }
            account.screen_name = result["screen_name"] as? String
            account.avatar_large = result["avatar_large"] as? String
            
            Infolog(account)
        }
    }
}
