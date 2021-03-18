//
//  INSLatestView.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/22.
//

import UIKit

class INSLatestView: SSCoverView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var upToDateLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    var confirmBlock: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 加载xib
        // swiftlint:disable force_cast
        view = (Bundle.main.loadNibNamed("INSLatestView", owner: self, options: nil)?.last as! UIView)
        // swiftlint:enable force_cast
        // 设置frame
        view.frame = frame
        
        confirmBtn.setRadius(20)
        confirmBtn.backgroundColor = AppGlobalThemeColor
        
        // 添加上去
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func confirmBtnClicked(_ sender: Any) {
        if confirmBlock != nil
        {
            confirmBlock!()
        }
    }
}
