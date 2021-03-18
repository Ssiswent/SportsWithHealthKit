//
//  INSHelpViewController.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/28.
//

import UIKit
import Lottie

class INSHelpViewController: INSBaseViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    var lottieView: LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLottieView()
        
        setTitle("帮助反馈")

        bgView.backgroundColor = .white
        bgView.setRadius(10)
        bgView.setShadow(color: UIColor(hexString: "#B11C18", alpha: 0.1), opacity: 1, radius: 5, offset: CGSize(width: 0, height: 1))
        view1.backgroundColor = .white
        view1.setRadius(10)
        view1.setShadow(color: UIColor(hexString: "#B11C18", alpha: 0.1), opacity: 1, radius: 5, offset: CGSize(width: 0, height: 1))
        view2.backgroundColor = .white
        view2.setRadius(10)
        view2.setShadow(color: UIColor(hexString: "#B11C18", alpha: 0.1), opacity: 1, radius: 5, offset: CGSize(width: 0, height: 1))
    }
    
    func addLottieView() {
        lottieView = .init(name: "lottie_feedback")
        lottieView?.frame = .zero
        
        lottieView?.contentMode = .scaleAspectFill
        
        lottieView?.loopAnimation = true
//        lottieView?.animationSpeed = 0.5
        view.addSubview(lottieView!)
        
        lottieView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 300, height: 246))
        })
        
        lottieView?.play()
    }
}

extension INSHelpViewController: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return [.backgroundStyleOpaque, .backgroundStyleColor, .styleBlack]
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
    
    func yp_navigationBackgroundColor() -> UIColor! {
        AppGlobalThemeColor
    }
}
