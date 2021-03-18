//
//  TNNoDataView.swift
//  TheNewOne
//
//  Created by 孟子弘 on 2019/4/3.
//  Copyright © 2019年 mzh. All rights reserved.
//

import UIKit
import Lottie

class SSEmptyView: UIView {
    fileprivate var noDataTitle: String?
    fileprivate var handleAction: (() -> Void)?
    
    fileprivate var lottieName: String?
    fileprivate var lottieView: LOTAnimationView?
    
    @objc init(frame: CGRect, lottieStr: String, title: String, action: @escaping (() -> Void)) {
        super.init(frame: frame)
        lottieName = lottieStr
        noDataTitle = title
        handleAction = action
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        backgroundColor = .clear
        
        addLottieView()
        
        let titleLabel = UILabel.init(frame: CGRect.zero)
        titleLabel.text = noDataTitle
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.54,alpha:1)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(lottieView!.snp.bottom).offset(20)
        }
        
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapAction)))
        
    }
    
    func addLottieView() {
        lottieView = .init(name: lottieName!)
        lottieView?.frame = .zero
        
        lottieView?.contentMode = .scaleAspectFill
        
        lottieView?.loopAnimation = true
//        lottieView?.animationSpeed = 0.5
        addSubview(lottieView!)
        
        lottieView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(0)
            make.size.equalTo(CGSize(width: 213, height: 145))
            //100,79
        })
        
        lottieView?.play()
    }
    
    @objc fileprivate func tapAction() {
        if handleAction != nil {
            handleAction!()
        }
    }
}
