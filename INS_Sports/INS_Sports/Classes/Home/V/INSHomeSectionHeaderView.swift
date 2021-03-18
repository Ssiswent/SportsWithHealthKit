//
//  HomeSectionHeaderView.swift
//  Futures-07
//
//  Created by Ssiswent on 2020/7/29.
//

import UIKit

typealias MoreBtnBlock = () -> Void

class INSHomeSectionHeaderView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    
    var moreBtnBlock: MoreBtnBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 加载xib
        // swiftlint:disable force_cast
        view = (Bundle.main.loadNibNamed("INSHomeSectionHeaderView", owner: self, options: nil)?.last as! UIView)
        // swiftlint:enable force_cast
        // 设置frame
        view.frame = frame
        
        view.backgroundColor = .clear
        
        // 添加上去
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func moreBtnClicked(_ sender: Any) {
        if moreBtnBlock != nil
        {
            moreBtnBlock!()
        }
    }
}
