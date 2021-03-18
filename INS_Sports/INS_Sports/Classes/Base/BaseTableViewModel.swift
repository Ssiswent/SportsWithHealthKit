//
//  BaseTableViewModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import Foundation
import UIKit
import ViewAnimator

public protocol TableSectionModelInterface {
    var cellModels: [TableCellProvider]? {get set}
    /// Warning! Not a reusable header
    var header: UIView? {get set}
    var headerHeight: CGFloat {get set}
    /// Warning! Not a reusable footer
    var footer: UIView? {get set}
    var footerHeight: CGFloat {get set}
}

public protocol TableCellModelInterface {}

public extension TableCellModelInterface {
    func cellModel() -> TableCellModelInterface {
        return self
    }
}

public protocol TableCellProvider {
    func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func bindModel(_ cell :TableCellInterface)
    func cellModel() -> TableCellModelInterface
}

public extension TableCellProvider {
    func dequeueAndBind(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(fromTableView: tableView, indexPath: indexPath)
        self.bindModel(cell as! TableCellInterface)
        return cell
    }
    
    func bindModel(_ cell: TableCellInterface) {
        var cell = cell
        cell.model = self.cellModel()
    }
}

public protocol TableCellInterface {
    var model: TableCellModelInterface? {get set}
}

open class BaseTableSectionModel: TableSectionModelInterface {
    
    /// Warning! Not a reusable header
    public var header: UIView?
    public var headerHeight: CGFloat = 0.0
    
    /// Warning! Not a reusable footer
    public var footer: UIView?
    public var footerHeight: CGFloat = 0.0
    
    public var cellModels: [TableCellProvider]?
    
//    public init() {}
}

let PlainCellSeparatorZero = CGFloat(0.0)
let GroupCellSeparatorZero = CGFloat(0.01)

public typealias CellDidSelected = (_ indexPath: IndexPath, _ cellModel: Any?) -> Void

open class BaseTableViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    struct Anim {
        static let vectorAnim = [AnimationType.vector(CGVector(dx: 0, dy: -70))]
        static let zoomAnim = [AnimationType.zoom(scale: 0.5)]
        static let rotateAnim = [AnimationType.random()]
        static let mixAnim = [AnimationType.zoom(scale: 0.2), AnimationType.rotate(angle: CGFloat.pi/6)]
    }
    
    public var tableView: UITableView!
    
    var talksArray = [INSTalkModel]()
    
    let cellAnim = Anim.vectorAnim
    
    var pageNumber: Int = 1
    var blockedTalks = [INSTalkModel]()
//    lazy var collectedBooks = [INSBookModel]()
    
    public init(table: UITableView) {
        super.init()
        tableView = table
        configTable()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configTable() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView.backgroundColor = .clear
    }
    
    public var cellDidSelected: CellDidSelected?
    
    public var data: Array<TableSectionModelInterface>?
    
    public func reload() {
        tableView.reloadData()
    }
    
    public func sectionModelOfIndex(_ index: Int) -> TableSectionModelInterface? {
        guard let section = data?[index] else {
            return nil
        }
        return section
    }
    
    public func cellModelOfIndexPath(_ indexPath: IndexPath) -> TableCellProvider? {
        guard let section = sectionModelOfIndex(indexPath.section), let cells = section.cellModels else {
            return nil
        }
        return cells[indexPath.row]
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return data?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = data?[section], let cells = sec.cellModels else {
            return 0
        }
        return cells.count
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionModelOfIndex(section)?.headerHeight ?? (tableView.style == .grouped ? GroupCellSeparatorZero : PlainCellSeparatorZero)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionModelOfIndex(section)?.header
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionModelOfIndex(section)?.footerHeight ?? (tableView.style == .grouped ? GroupCellSeparatorZero : PlainCellSeparatorZero)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionModelOfIndex(section)?.footer
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cellModelOfIndexPath(indexPath) else {
            return UITableViewCell()
        }
        return cell.dequeueAndBind(fromTableView: tableView, indexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selected = cellDidSelected {
            let model = cellModelOfIndexPath(indexPath)
            selected(indexPath, model)
        }
    }
}

extension BaseTableViewModel {
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
    
    func getTalks(pageNum: Int) -> INSBaseViewModel {
        let vm = INSBaseViewModel()
        getTalksRequest(pageNum: pageNum) { (response) in
            vm.handleResponse(response: response)
        }
        return vm
    }
    
    /// 获取说说
    func getTalksRequest(pageNum: Int, completionHandler: @escaping (SSDataResponse) -> Void) {
        getBlockedTalks()
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
                }
            }
            let response = SSDataResponse(isSuccess: true, data: "success")
            completionHandler(response)
        }.failed { (error) in
            let response = SSDataResponse(isSuccess: false, data: error)
            completionHandler(response)
        }
    }
}
