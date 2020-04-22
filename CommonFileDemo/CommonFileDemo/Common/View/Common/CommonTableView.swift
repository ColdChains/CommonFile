//
//  CommonTableView.swift
//  FreightUser
//
//  Created by lax on 2019/8/23.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CommonTableView: UITableView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if let v = view, !(v.isKind(of: UITextField.self) || v.isKind(of: UITextView.self)) {
            endEditing(true)
        }
        return view
    }
    
//    - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    id view = [super hitTest:point withEvent:event];
//    //点击tableview收起键盘
//    if (![view isKindOfClass:[UITextView class]] && isShowKeyboard == YES) {
//    [self endEditing:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    [self setContentOffset:CGPointMake(0, self->offSetY) animated:YES];
//    });
//    }
//    return view;
//    }
    
    var dataArray: [CellModel] = []
    
    init() {
        super.init(frame: CGRect(), style: .plain)
        initView()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        initView()
    }
        
    private func initView() {
        
        delegate = self
        dataSource = self
        backgroundColor = .clear
        separatorStyle = .none
        estimatedRowHeight = 100
        rowHeight = UITableView.automaticDimension
        tableHeaderView = UIView()
        tableFooterView = UIView()
        
        register(UINib(nibName: CommonTableViewCell.className, bundle: nil), forCellReuseIdentifier: CommonTableViewCell.className)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        
//        mj_header = MJRefressManager.animationHeader(block: { () in
//            let time: TimeInterval = 2.0
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
//                //code
//                mj_header.endRefreshing()
//            }
//        })
//        mj_header = MJRefressManager.defaultHeader {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                self.mj_header.endRefreshing()
//            }
//        }
//        mj_footer = MJRefressManager.defaultFooter {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                self.mj_footer.endRefreshing()
//            }
//        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension CommonTableView : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewCell.className) as! CommonTableViewCell
        cell.setData(model: dataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if let vc = UIViewController.viewController(for: dataArray[indexPath.row].push) {
            navigationController?.pushViewController(vc, animated: true)
        }
        if let action = dataArray[indexPath.row].action, responds(to: Selector(action)) {
            let control: UIControl = UIControl()
            control.sendAction(Selector(action), to: self, for: nil)
        }
    }
    
}
