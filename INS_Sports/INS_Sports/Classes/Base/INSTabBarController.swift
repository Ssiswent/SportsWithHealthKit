//
//  INSTabBarController.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import UIKit
import CYLTabBarController

class INSTabBarController: CYLTabBarController {
    
    var selectedCover: UIButton?
    
    //初始化TabBarController
    class func initTabBarController() -> (INSTabBarController)
    {
        //是否添加中间的Btn
        //        INSPlusBtn.register()
        //设置内容
        let customTBC = INSTabBarController(viewControllers: viewControllers(), tabBarItemsAttributes: tabBarItemsAttributesForController())
        return customTBC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        
        //开启半透明毛玻璃效果，但是不能设置bgcolor
//        UITabBar.appearance().isTranslucent = true
        configureStyle()
    }

    // MARK: 设置标签栏控制器
    class func viewControllers() -> [INSBaseNavigationController]
    {
        let homeNav = INSBaseNavigationController(rootViewController: INSHomeVC())
        let healthNav = INSBaseNavigationController(rootViewController: INSHealthVC())
        let findNav = INSBaseNavigationController(rootViewController: INSFindViewController())
        let meNav = INSBaseNavigationController(rootViewController: INSMineVC())
        
        let viewControllers = [homeNav, healthNav, findNav, meNav]
        
        return viewControllers
    }
    
    // MARK: 设置标签栏内容
    class func tabBarItemsAttributesForController() -> [[String: Any]]
    {
        let home = [
                    CYLTabBarItemTitle: "首页",
                    CYLTabBarLottieURL: Bundle.main.url(forResource: "lottie_home", withExtension: "json") as Any
                ] as [String : Any]
        let health = [
                    CYLTabBarItemTitle: "健康",
                    CYLTabBarLottieURL: Bundle.main.url(forResource: "lottie_health", withExtension: "json") as Any
                ] as [String : Any]
        let find = [
                    CYLTabBarItemTitle: "发现",
                    CYLTabBarLottieURL: Bundle.main.url(forResource: "lottie_find", withExtension: "json") as Any
                ] as [String : Any]
        let me = [
                    CYLTabBarItemTitle: "我的",
                    CYLTabBarLottieURL: Bundle.main.url(forResource: "lottie_me", withExtension: "json") as Any
                ] as [String : Any]
        
        let tabBarItemsAttributes = [home, health, find, me]
        
        return tabBarItemsAttributes
    }
    
    //样式配置
    func configureStyle() {
        // 背景颜色
        let bgColor = UIColor.clear
        // 未选中颜色
        let normalColor = UIColor(hexString: "#130000")
        // 选中颜色
        let selectedColor = UIColor(hexString: "#FA472F")
        //未选中字体
        var normalAttrs = [NSAttributedString.Key:Any]()
        normalAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 11, weight: .regular)
        normalAttrs[NSAttributedString.Key.foregroundColor] = normalColor
        //选中字体
        var selectedAttrs = [NSAttributedString.Key:Any]()
        selectedAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 11, weight: .medium)
        selectedAttrs[NSAttributedString.Key.foregroundColor] = selectedColor

        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage.imageWithColor(color: .clear)
        //背景颜色
        tabBar.backgroundColor = bgColor
        //未选中颜色
        tabBar.unselectedItemTintColor = normalColor
        //选中颜色
        tabBar.tintColor = selectedColor
        //设置字体
        let tabBarApp = UITabBarItem.appearance()
        tabBarApp.setTitleTextAttributes(normalAttrs, for: .normal)
        tabBarApp.setTitleTextAttributes(selectedAttrs, for: .selected)
        
        //设置阴影
//        tabBar.layer.shadowColor = UIColor(hexString: "#000000", alpha: 0.1).cgColor
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        tabBar.layer.shadowRadius = 10
//        tabBar.layer.shadowOpacity = 0.3
    }
}

extension INSTabBarController
{
    override func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        updateSelectionStatusIfNeeded(for: tabBarController, shouldSelect: viewController)
        return true
    }
    
//    override func tabBarController(_ tabBarController: UITabBarController, didSelect control: UIControl) {
//
//        var animationView: UIView?
//
//        //        let isPlusBtn: Bool = control.isKind(of: CYLExternPlusButton.classForCoder)
//        let isTabBtn: Bool = control.isKind(of: NSClassFromString("UITabBarButton")!)
//
//        //        if isPlusBtn
//        //        {
//        //            let button = CYLExternPlusButton
//        //            animationView = button.imageView
//        //        }
//        if isTabBtn
//        {
//            for subView in control.subviews
//            {
//                if subView.isKind(of: NSClassFromString("UITabBarSwappableImageView")!)
//                {
//                    animationView = subView
//                }
//            }
//        }
//
//        addScaleAnim(animationView: animationView)
//
//        //设置仿淘宝
////        //        if isPlusBtn || isTabBtn {
////        if isTabBtn {
////            let shouldSelectedCoverShow: Bool = self.selectedIndex == 0
////            setSelectedCoverShow(shouldSelectedCoverShow)
////        }
//    }
    
    //缩放动画
    func addScaleAnim(animationView: UIView?)
    {
        //需要实现的帧动画，这里根据需求自定义
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.scale"
        animation.values = [NSNumber(value: 1.0), NSNumber(value: 1.3), NSNumber(value: 0.9), NSNumber(value: 1.15), NSNumber(value: 0.95), NSNumber(value: 1.02), NSNumber(value: 1.0)]
        animation.duration = 0.8
        animation.calculationMode = .cubic
        animationView?.layer.add(animation, forKey: nil)
    }
    
    //旋转动画
    func addRotateAnim(animationView: UIView?) {
        UIView.animate(withDuration: 0.32, delay: 0, options: .curveEaseIn, animations: {
            animationView?.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.70, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
                animationView?.layer.transform = CATransform3DMakeRotation(2 * .pi, 0, 1, 0)
            })
        })
    }
    
    func setSelectedCoverShow(_ show: Bool) {
        let selectedTabButton = viewControllers[0].tabBarItem.cyl_tabButton
        selectedTabButton.cyl_replaceTabButton(withNewView: self.getSelectedCover(), show: show)
        if show {
            addOnceScaleAnim(animationView: self.getSelectedCover())
        }
    }
    
    func getSelectedCover() -> UIButton {
        if selectedCover != nil {
            return selectedCover!
        }
        let selectedCover = UIButton(type: .custom)
        let image = UIImage(named: "icon_home-")
        selectedCover.setImage(image?.originalImg(), for: .normal)
        selectedCover.frame = {
            var frame = selectedCover.frame
            frame.size = CGSize(width: 35, height: 35)
            return frame
        }()
        selectedCover.translatesAutoresizingMaskIntoConstraints = false
        // selectedCover.userInteractionEnabled = false;
        self.selectedCover = selectedCover
        return self.selectedCover!
    }
    
    //缩放动画
    func addOnceScaleAnim(animationView: UIView?)
    {
        //需要实现的帧动画，这里根据需求自定义
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.scale"
        animation.values = [NSNumber(value: 0.9), NSNumber(value: 1.0)]
        animation.duration = 0.2
        animation.calculationMode = .cubic
        animationView?.layer.add(animation, forKey: nil)
    }
}
