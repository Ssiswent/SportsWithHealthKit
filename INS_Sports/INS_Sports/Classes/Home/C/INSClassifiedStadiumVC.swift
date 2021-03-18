//
//  INSClassifiedStadiumVC.swift
//  SAKBallSports
//
//  Created by Flamingo on 2020/12/16.
//

import UIKit

enum StadiumType: String {
    case 乒乓球 = "乒乓球"
    case 足球 = "足球"
    case 羽毛球 = "羽毛球"
    case 网球 = "网球"
}

class INSClassifiedStadiumVC: INSBaseViewController {
    
    var stadiumType: String = "乒乓球"
    
    var stadiumsArray = [INSStadiumModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        getStadiumsByType()
    }
    
    func initialize()
    {
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        setTitle(stadiumType + "馆")
        setTableView()
    }
    
    func setTableView()
    {
        addTableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .clear
        weak var weakSelf = self
        tableView?.mj_header = SSRefreshHeader.getRefreshHeader {
            weakSelf?.refreshData()
        }
        tableView?.mj_footer = SSRefreshFooter.getRefreshFooter {
            weakSelf?.refreshData()
        }
        
        registerCell(cell: INSClassifiedStadiumCell.self)
    }
    fileprivate func refreshData() {
        pageNumber = 1
        getStadiumsByType()
    }
    fileprivate func lodeMore() {
        pageNumber += 1
        getStadiumsByType()
    }
}

extension INSClassifiedStadiumVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stadiumsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "INSClassifiedStadiumCell", for: indexPath) as! INSClassifiedStadiumCell
        cell.moreOrLessBlock = {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.model = stadiumsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        17
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = INSStaduimDetailsViewController()
        vc.stadiumModel = stadiumsArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: API
extension INSClassifiedStadiumVC
{
    func getStadiumsByType() {
        weak var weakSelf = self
        var params = [String:Any]()
        params["pageNum"] = pageNumber
        params["typeName"] = stadiumType
        SSNetwork.shared.GET(URLStr: API.getStadiums, params: params).success { (result) in
            if let dict = result as? [String: Any] {
                if dict["success"] as? Bool ?? false {
                    if let arr = INSStadiumModel.mj_objectArray(withKeyValuesArray: (dict["data"] as? [String: Any])?["list"]) as? [INSStadiumModel] {
                        if weakSelf?.pageNumber == 1 {
                            weakSelf?.stadiumsArray = arr
                        } else {
                            if arr.count > 0 {
                                weakSelf?.stadiumsArray += arr
                            } else {
                                weakSelf?.pageNumber -= 1
                            }
                        }
                        weakSelf?.tableView?.reloadSections(IndexSet(integer: 0), with: .none)
                        if let cells = weakSelf?.tableView?.visibleCells(in: 0)
                        {
                            UIView.animate(views: cells, animations: weakSelf!.cellAnim, duration: 0.5)
                        }
                    }
                }
                else
                {
                    SVProgressHUD.gp_show(withStatus: dict["msg"] as? String ?? "error", delay: 2)
                }
            }
            weakSelf?.tableView?.mj_header.endRefreshing()
            weakSelf?.tableView?.mj_footer.endRefreshing()
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: "网络错误", delay: 1)
            weakSelf?.tableView?.mj_header.endRefreshing()
            weakSelf?.tableView?.mj_footer.endRefreshing()
        }
    }
}

extension INSClassifiedStadiumVC: NavigationBarConfigureStyle
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
