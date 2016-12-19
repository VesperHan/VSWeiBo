//
//  ComposeViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/14.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    fileprivate lazy var picImages :[UIImage] = [UIImage]()
    fileprivate lazy var emoticonVC : EmoticonController = EmoticonController { [weak self](emoticon) in
        
        self?.textView.insertEmoticonIntoTextView(emoticon: emoticon)
        self?.textViewDidChange(self!.textView)
    }
    
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var collectHCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
}

extension ComposeViewController {

    fileprivate func setupNavigationBar() {
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClk))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(sendItemClk))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    fileprivate func setupNotifications(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClk), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClk(note:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
}

// MARK:- 添加删除照片
extension ComposeViewController {
 
    @objc fileprivate func addPhotoClk(){
        //必须在plist里面添加权限否则导致程序崩溃
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        let ipc = UIImagePickerController()
        ipc.delegate = self;
        ipc.sourceType = .photoLibrary
        present(ipc, animated: true, completion: nil)
    }
    
    @objc fileprivate func removePhotoClk(note:Notification){
    
        guard let image = note.object as? UIImage else{
            return
        }
        
        //直接找到该照片,因为数组里面定义的就是存照片
        guard let index = picImages.index(of: image) else {
            return
        }
        picImages.remove(at: index)
        picPickerView.images = picImages
    }
}

//必须遵守navigation
extension ComposeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picImages.append(image)
        picPickerView.images = picImages
        
        //模态退出
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ComposeViewController {

    @objc fileprivate func closeItemClk(){
    
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func sendItemClk(){
    
        // 0.键盘退出
        textView.resignFirstResponder()
        
        // 1.获取发送微博的微博正文
        let statusText = textView.getEmoticonString()
        
        let finishedCalback = {(isSuccess:Bool)->() in
            
            if !isSuccess{
            
                SVProgressHUD.showError(withStatus: "send failed")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "send success")
            self.dismiss(animated: true, completion: nil)
        }

        if let image = picImages.first{
        
            VSNetworkTools.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: finishedCalback)
        }else{
        
            VSNetworkTools.shareInstance.sendStatus(statusText: statusText, isSuccess: finishedCalback)
        }
    }
    
    @objc fileprivate func keyboardWillChangeFrame(note:Notification){

        let duration = note.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        
        let endFrame = (note.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        
        let y = endFrame.origin.y
        
        let margin = UIScreen.main.bounds.height - y
        
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) {
         
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClk(_ sender: UIButton) {

        if sender.isSelected == true {
            
            sender.isSelected = false
            picImages.removeAll()
            picPickerView.images = picImages
            collectHCons.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            return
        }
        sender.isSelected = true
        textView.resignFirstResponder()
        collectHCons.constant = UIScreen.main.bounds.height * 0.6
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func emoticonBtnClk(_ sender: Any) {
        
        textView.resignFirstResponder()
        //切换键盘
        textView.inputView = textView.inputView != nil ? nil : emoticonVC.view
        textView.becomeFirstResponder()
    }
}

extension ComposeViewController:UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        
        self.textView.placeHolderLb.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
        textView.resignFirstResponder()
    }
}
