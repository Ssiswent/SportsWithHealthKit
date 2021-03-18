//
//  INSHomeHeaderView.swift
//  Futures_Remix
//
//  Created by Ssiswent on 2020/9/27.
//

import UIKit
import FSPagerView

class INSHomeHeaderView: UIView {
    
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 加载xib
        // swiftlint:disable force_cast
        view = (Bundle.main.loadNibNamed("INSHomeHeaderView", owner: self, options: nil)?.last as! UIView)
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
        view.backgroundColor = .clear
//        alertView.setShadow(color: UIColor(hexString: "#000000", alpha: 0.1), opacity: 1, radius: 12, offset: CGSize(width: 2, height: 2))
    }
    
    @IBAction func pingPongBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.乒乓球.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func badmintonBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.羽毛球.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tennisBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.网球.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func basketballBtnClicked(_ sender: Any) {
        let vc = INSClassifiedStadiumVC()
        vc.stadiumType = StadiumType.足球.rawValue
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
