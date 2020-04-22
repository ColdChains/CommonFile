//
//  KeyBoardTableView.swift
//  FreightUser
//
//  Created by lax on 2019/8/29.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class KeyBoardTableView: UITableView {

    private var isShowKeyboard: Bool = false
    private var offSetY: CGFloat = 0
    private var scrollOffSetY: CGFloat = 0
    
    func addObserverForKeyboard(offSetY: CGFloat = 0) {
        scrollOffSetY = offSetY
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserverForKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShowAction(_ notification: Notification) {
//        guard let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//        let keyboardHeight = keyboardRect.size.height;
//        guard let beginRect = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
//        guard let endRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//        if beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y > 0) {
//            setContentOffset(CGPoint(x: 0, y: 300), animated: true)
//        }
        if !isShowKeyboard {
            DispatchQueue.main.async {
                self.isShowKeyboard = true
                self.offSetY = self.contentOffset.y
                self.setContentOffset(CGPoint(x: 0, y: self.scrollOffSetY), animated: true)
            }
        }
    }
    
    @objc func keyboardHideAction() {
        if isShowKeyboard {
            DispatchQueue.main.async {
                self.isShowKeyboard = false
                self.setContentOffset(CGPoint(x: 0, y: self.offSetY), animated: true)
            }
        }
    }

}
