//
//  ChangeInfoView.swift
//  Futures-07
//
//  Created by Ssiswent on 2020/8/7.
//

import UIKit

class INSChangeInfoView: SSCoverView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textF: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    typealias ClickCancelBlock = () -> Void
    typealias ClickConfirmBlock = (String) -> Void
    
    var clickCancelBlock: ClickCancelBlock?
    var clickConfirmBlock: ClickConfirmBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 加载xib
        // swiftlint:disable force_cast
        view = (Bundle.main.loadNibNamed("INSChangeInfoView", owner: self, options: nil)?.last as! UIView)
        // swiftlint:enable force_cast
        // 设置frame
        view.frame = frame
        
        setUpView()

        // 添加上去
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView()
    {
        view.backgroundColor = .white
        textF.textColor = .black
        
        bgView.backgroundColor = #colorLiteral(red: 0.9489468932, green: 0.9490606189, blue: 0.9489082694, alpha: 1)
        bgView.setRadius(4)
        
        view.setRadius(10)
        
        cancelBtn.setTitleColor(UIColor(hexString: "#999999"), for: .normal)
        cancelBtn.backgroundColor = UIColor(hexString: "#E2E2E2")
        
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.backgroundColor = UIColor(hexString: "#376AEB")
        
        cancelBtn.setTitle(localizableStr("Cancel"), for: .normal)
        confirmBtn.setTitle(localizableStr("Confirm"), for: .normal)
    }

    @IBAction func cancelBtnClicked(_ sender: Any) {
        if clickCancelBlock != nil
        {
            clickCancelBlock!()
        }
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        if clickConfirmBlock != nil
        {
            clickConfirmBlock!(textF.text!)
        }
    }
}
