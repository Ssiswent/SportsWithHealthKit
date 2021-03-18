//
//  INSPhotoView.swift
//  Futures-0824
//
//  Created by Ssiswent on 2020/8/29.
//

import UIKit

class INSPhotoView: SSCoverView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var funcView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var photoLabel: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    var albumBlock: (() -> Void)?
    var cameraBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 加载xib
        // swiftlint:disable force_cast
        view = (Bundle.main.loadNibNamed("INSPhotoView", owner: self, options: nil)?.last as! UIView)
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
        funcView.setRadius(13)
        selectLabel.textColor = AppGlobalThemeColor
        photoLabel.textColor = AppGlobalThemeColor
        cancelBtn.backgroundColor = AppGlobalThemeColor
    }

    @IBAction func albumBtnClicked(_ sender: Any) {
        if albumBlock != nil
        {
            albumBlock!()
        }
    }
    
    @IBAction func cameraBtnClicked(_ sender: Any) {
        if cameraBlock != nil
        {
            cameraBlock!()
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        if cancelBlock != nil
        {
            cancelBlock!()
        }
    }
}
