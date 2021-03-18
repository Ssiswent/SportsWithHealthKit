//
//  INSHomeHotCell.swift
//  Futures_Remix
//
//  Created by Ssiswent on 2020/9/27.
//

import UIKit
import ViewAnimator

class INSHomeHotCell: UITableViewCell, TableCellInterface {
    var model: TableCellModelInterface?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hasOrdered1 = false
    var hasOrdered2 = false
    var hasOrdered3 = false
    
    var stadiumsArray = [INSStadiumModel]()
    var collectedStadiums = [INSStadiumModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setCollectionView()
        reloadData()
    }
    
    override func didMoveToWindow() {
        if self.window != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "TableViewRefresh"), object: nil)
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func reloadData() {
        getCollctedStadiums()
        getStadiumsRequest()
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 240)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "INSHomeHotCollectionCell", bundle: nil), forCellWithReuseIdentifier: "INSHomeHotCollectionCell")
    }
    
    @IBAction func order1BtnClicked(_ sender: Any) {
        if hasOrdered1 {
            SVProgressHUD.gp_showInfo(withStatus: "您已预约", delay: 1)
        } else {
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.gp_showSuccess(withStatus: "预约成功", delay: 1)
            }
            hasOrdered1 = true
        }
    }
    
    @IBAction func order2BtnClicked(_ sender: Any) {
        if hasOrdered2 {
            SVProgressHUD.gp_showInfo(withStatus: "您已预约", delay: 1)
        } else {
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.gp_showSuccess(withStatus: "预约成功", delay: 1)
            }
            hasOrdered2 = true
        }
    }
    
    @IBAction func order3BtnClicked(_ sender: Any) {
        if hasOrdered3 {
            SVProgressHUD.gp_showInfo(withStatus: "您已预约", delay: 1)
        } else {
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.gp_showSuccess(withStatus: "预约成功", delay: 1)
            }
            hasOrdered3 = true
        }
    }
    
}

extension INSHomeHotCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if stadiumsArray.count >= 6
        {
            return 6
        }
        else
        {
            return stadiumsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "INSHomeHotCollectionCell", for: indexPath) as! INSHomeHotCollectionCell
        let stadiumModel = stadiumsArray[indexPath.row]
        cell.model = stadiumModel
        cell.collectedStadiums = collectedStadiums
        cell.collectBlock = {
            self.collectedStadiums.append(stadiumModel)
            self.collectionView.reloadData()
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(self.collectedStadiums) {
                UserDefaults.standard.set(data, forKey: "collctedStadiumsArray")
            }
        }
        cell.cancelBlock = {
            var index: Int = -1
            for model in self.collectedStadiums {
                index += 1
                if stadiumModel.id == model.id
                {
                    self.collectedStadiums.remove(at: index)
                    self.collectionView.reloadData()
                    break
                }
            }
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(self.collectedStadiums) {
                UserDefaults.standard.set(data, forKey: "collctedStadiumsArray")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = INSStaduimDetailsViewController()
        let model = stadiumsArray[indexPath.row]
        vc.stadiumModel = model
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension INSHomeHotCell {
    func getStadiumsRequest() {
        SVProgressHUD.show()
        weak var weakSelf = self
        var params = [String:Any]()
        params["pageNum"] = 1
        params["pageSize"] = 6
        SSNetwork.shared.GET(URLStr: API.getStadiums, params: params).success { (result) in
            if let dict = result as? [String:Any] {
                if let arr = INSStadiumModel.mj_objectArray(withKeyValuesArray: (dict["data"] as? [String: Any])?["list"]) as? [INSStadiumModel] {
                    weakSelf?.stadiumsArray = arr
                    SVProgressHUD.dismiss()
                    weakSelf?.collectionView.reloadSections(IndexSet(integer: 0))
                    if let cells = weakSelf?.collectionView.visibleCells(in: 0) {
                        UIView.animate(views: cells,
                                       animations: BaseTableViewModel.Anim.vectorAnim,
                                       duration: 0.5)
                    }
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"))
            SVProgressHUD.dismiss()
        }
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
    }
}
