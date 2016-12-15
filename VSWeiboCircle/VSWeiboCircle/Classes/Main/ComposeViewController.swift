//
//  ComposeViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/14.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var collectHCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
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
}

extension ComposeViewController {

    @objc fileprivate func closeItemClk(){
    
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func sendItemClk(){
    
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
    
    @IBAction func picPickerBtnClk(_ sender: Any) {
        
        textView.resignFirstResponder()
        collectHCons.constant = UIScreen.main.bounds.height * 0.6
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
