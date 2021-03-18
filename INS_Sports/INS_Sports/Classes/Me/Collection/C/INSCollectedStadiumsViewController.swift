//
//  INSCollectedStadiumsViewController.swift
//  SAKBallSports
//
//  Created by Flamingo on 2020/12/18.
//

import UIKit

class INSCollectedStadiumsViewController: INSBaseViewController {
    
    var collectedStadiums = [INSStadiumModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCollctedStadiums()
    }
    
    func initialize()
    {
        setTitle("我的收藏")
        setTableView()
    }
    
    func setTableView()
    {
        addTableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .clear
        registerCell(cell: INSClassifiedStadiumCell.self)
    }
    
    /// 获取收藏球馆数组
    func getCollctedStadiums()
    {
        if UserDefaults.standard.object(forKey: "collctedStadiumsArray") == nil {
            let stadiums = [INSStadiumModel]()
            self.collectedStadiums = stadiums
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(stadiums) {
                UserDefaults.standard.set(data, forKey: "collctedStadiumsArray")
            }
        } else {
            let decoder = JSONDecoder()
            // swiftlint:disable force_cast
            if let data = UserDefaults.standard.object(forKey: "collctedStadiumsArray"), let stadiums = try? decoder.decode([INSStadiumModel].self, from: data as! Data)
            {
                self.collectedStadiums = stadiums
            }
            // swiftlint:enable force_cast
        }
        tableView?.reloadData()
        if let cells = tableView?.visibleCells(in: 0) {
            UIView.animate(views: cells, animations: cellAnim, duration: 0.5)
        }
    }
}

extension INSCollectedStadiumsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.viewDisplayImage(withMsg: "暂无收藏", lottieStr: "lottie_empty", action: {}, ifNecessaryForRowCount: collectedStadiums.count)
        return collectedStadiums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "INSClassifiedStadiumCell", for: indexPath) as! INSClassifiedStadiumCell
        cell.moreOrLessBlock = {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.model = collectedStadiums[indexPath.row]
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
        vc.stadiumModel = collectedStadiums[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension INSCollectedStadiumsViewController: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return [.backgroundStyleOpaque, .backgroundStyleColor, .styleBlack]
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
    
    func yp_navigationBackgroundColor() -> UIColor! {
        UIColor(hexString: "#EC675A")
    }
}
