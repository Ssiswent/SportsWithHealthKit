//
//  INSBaseViewController.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import UIKit
import ViewAnimator

class INSBaseViewController: UIViewController {
    
    struct Anim {
        static let vectorAnim = [AnimationType.vector(CGVector(dx: 0, dy: -70))]
        static let zoomAnim = [AnimationType.zoom(scale: 0.5)]
        static let rotateAnim = [AnimationType.random()]
        static let mixAnim = [AnimationType.zoom(scale: 0.2), AnimationType.rotate(angle: CGFloat.pi/6)]
    }
    
    let cellAnim = Anim.vectorAnim
    
    var pageNumber: Int = 1
    
    var blockedTalks = [INSTalkModel]()
    
    var tableView: UITableView?
    var talksArray = [INSTalkModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        
        extendedLayoutIncludesOpaqueBars = true
        
        setBackBtn()
        
        getBlockedTalks()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    //设置返回按钮
    func setBackBtn() {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "nav_back_btn_light"), style: .plain, target: self, action: #selector(back))
        }
    }
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func addTableView()
    {
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - KBottomSafeAreaValue), style: .grouped)
        tableView?.separatorStyle = .none
        tableView?.showsVerticalScrollIndicator = false
        tableView?.showsHorizontalScrollIndicator = false
        view.addSubview(tableView!)
    }
    
    func registerCell(cell: UITableViewCell.Type)
    {
        tableView?.register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: String(describing: cell))
    }
    
    func refresh(pageNum: Int, section: Int? = 0)
    {
        pageNumber = pageNum
        getTalks(pageNum: pageNum, section: section)
    }
    
    func nextPage(pageNum: Int, section: Int? = 0)
    {
        pageNumber += 1
       getTalks(pageNum: pageNum, section: section)
    }
    
    func addHeader(pageNum: Int, section: Int? = 0)
    {
        weak var weakSelf = self
        tableView?.mj_header = SSRefreshHeader.getRefreshHeader {
            weakSelf?.refresh(pageNum: pageNum, section: section)
        }
    }
    
    func addFooter(pageNum: Int, section: Int? = 0)
    {
        weak var weakSelf = self
        tableView?.mj_footer = SSRefreshFooter.getRefreshFooter {
            weakSelf?.nextPage(pageNum: pageNum, section: section)
        }
    }
    
    //获取屏蔽说说数组
    func getBlockedTalks()
    {
        if UserDefaults.standard.object(forKey: "SHIELDTALK") == nil
        {
            let shieldArray = [INSTalkModel]()
            self.blockedTalks = shieldArray
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(shieldArray) {
                UserDefaults.standard.set(data, forKey: "SHIELDTALK")
            }
        } else {
            let decoder = JSONDecoder()
            // swiftlint:disable force_cast
            if let data = UserDefaults.standard.object(forKey: "SHIELDTALK"), let shieldArray = try? decoder.decode([INSTalkModel].self, from: data as! Data)
            // swiftlint:enable force_cast
            {
                self.blockedTalks = shieldArray
            }
        }
    }
    
    //清空屏蔽的说说
    func deleteBlockedTalks()
    {
        let cleanShieldArray = [INSTalkModel]()
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(cleanShieldArray) {
            UserDefaults.standard.set(data, forKey: "SHIELDTALK")
        }
    }
}

// MARK: API
extension INSBaseViewController
{
    /// 获取说说
    func getTalks(pageNum: Int, section: Int? = 0)
    {
        SVProgressHUD.show()
        weak var weakSelf = self
        var params = [String: Any]()
        params["project"] = Project.sport1
        params["pageNumber"] = pageNumber
        
        if INSAccountManager.shared.isLogin {
            params["userId"] = INSAccountManager.shared.userId
        }
        SSNetwork.shared.GET(URLStr: API.getRecommendTalkList, params: params).success { (result) in
            if let dict = result as? [String: Any] {
                if let arr = INSTalkModel.mj_objectArray(withKeyValuesArray: (dict["data"] as? [String: Any])?["data"]) as? [INSTalkModel] {
                    if weakSelf?.pageNumber == pageNum {
                        weakSelf?.talksArray = arr
                    } else {
                        if arr.count > 0 {
                            weakSelf?.talksArray += arr
                        } else {
                            weakSelf?.pageNumber -= 1
                        }
                    }

                    //设置屏蔽
                    if self.blockedTalks.count > 0 {
                        for shieldModel in self.blockedTalks
                        {
                            var hasBlocked: Bool = false
                            var blockedIndex: Int = -1
                            for talkModel in self.talksArray
                            {
                                blockedIndex += 1
                                if talkModel.id == shieldModel.id
                                {
                                    hasBlocked = true
                                    break
                                }
                            }
                            if hasBlocked
                            {
                                weakSelf?.talksArray.remove(at: blockedIndex)
                            }
                        }
                    }
                    weakSelf?.tableView?.reloadData()
                    if let cells = weakSelf?.tableView?.visibleCells(in: section ?? 0)
                    {
                        UIView.animate(views: cells, animations: weakSelf!.cellAnim)
                    }
                }
            }
            SVProgressHUD.dismiss()
            weakSelf?.tableView?.mj_header.endRefreshing()
            weakSelf?.tableView?.mj_footer.endRefreshing()
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
            SVProgressHUD.dismiss()
            weakSelf?.tableView?.mj_header.endRefreshing()
            weakSelf?.tableView?.mj_footer.endRefreshing()
        }
    }
}
