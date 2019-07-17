//
//  LCYSearchViewController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/2.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYSearchViewController: LCYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        searchView.searchCallBack { [weak self] (comicId) in
            //点击了搜索历史中的item
            
            let vc = LCYComicController.init(comicId: comicId)
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        searchView.refreshBlock = { [weak self] in
            self?.requestHistory()
        }
        
        //监听键盘的高度变化
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)

        //请求热门搜索
        requestHistory()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: nil, style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", target: self, action: #selector(cancelAction))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods -------------
    
    func requestHistory() {
        ApiLoadingProvider.request(.searchHot, model: LCYHotItemsModel.self) { [weak self] (result) in
            self?.searchView.searchHistoryModel = result
        }
    }
    
    @objc func cancelAction() {
        self.searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    func search(_ text: String) {
        ApiLoadingProvider.request(.searchRelative(inputText: text), model: [LCYSearchItemModel].self) { [weak self] (result) in
            self?.searchView.searchResultModelArray = result
        }
    }
    
    @objc func keyboardWillShow(_ noti: Notification) {
        DispatchQueue.main.async {
            let info = noti.userInfo
            let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
            
            self.searchView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().offset(offsetY)
            })
            
            print("show = \(offsetY)")
        }
    }
    
    @objc func keyboardWillHide(_ noti: Notification) {
        DispatchQueue.main.async {
            let info = noti.userInfo
            let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
            
            self.searchView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview()
            })
            print("hide = \(offsetY)")
        }
    }
    
    // MARK: - lazy loading -------------
    lazy var searchBar: UITextField = {
        let textField = UITextField.init()
        textField.placeholder = "输入漫画名称/作者"
        textField.backgroundColor = .white
        textField.textColor = .gray
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = true
        textField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        textField.leftViewMode = .always
        textField.frame = CGRect(x: 0, y: 0, width: screenWidth - 50, height: 30)
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(notification:)), name: UITextField.textDidChangeNotification, object: textField)

        return textField
    }()
    
    lazy var searchView: LCYSearchView = {
        let view = LCYSearchView()
        
        return view
    }()
}


extension LCYSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let string = textField.text else {
            return false
        }
        
        self.search(string)
        
        return true
    }
    
    @objc func textFiledTextDidChange(notification: Notification) {
        guard let textField = notification.object as? UITextField,
            let text = textField.text else { return }
        self.search(text)
    }
}
