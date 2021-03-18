//
//  INSFindTableVM.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/11.
//

import UIKit

class INSFindTableVM: BaseTableViewModel {
    
    var talkCellModels = [INSHuDongTalkCellModel]()
    
    weak var publishBtn: UIButton!
    weak var goTopBtn: UIButton!
    var publishBtnBottomConstant: CGFloat = 103 + KDeviceBottomHeight
    var goTopBtnBottomConstant: CGFloat = 30 + KDeviceBottomHeight
    
    func build() {
        let section0 = BaseTableSectionModel()
        section0.cellModels = [INSFindUserCellModel()]
        
        let section1 = BaseTableSectionModel()
        section1.cellModels = talkCellModels
        self.data = [section0, section1]
    }
    
    func setTableView() {
        pageNumber = 1
        getBlockedTalks()
        
        tableView.register(INSFindUserCell.self)
        tableView.register(INSHuDongTalkCell.self)
        
        weak var weakSelf = self
        tableView.mj_header = SSRefreshHeader.getRefreshHeader {
            weakSelf?.pageNumber = 1
            weakSelf?.loadTalkData()
            NotificationCenter.default.post(Notification(name: Notification.Name("TableViewRefresh")))
        }
        tableView.mj_footer = SSRefreshFooter.getRefreshFooter {
            weakSelf?.pageNumber += 1
            weakSelf?.loadTalkData()
        }
        
        cellDidSelected = { (indexPath, cellModel) in
            if indexPath.section == 1 {
                let vc = INSTalkDetailsViewController()
                let cellModel = weakSelf?.talkCellModels[indexPath.row]
                vc.newsModel = cellModel?.model
                vc.rowIndex = indexPath.row
                vc.popBackBlock = {
                    NotificationCenter.default.addObserver(self, selector: #selector(self.deleteBlockedCell(_:)), name: NSNotification.Name(rawValue: "deleteBlockedCell"), object: nil)
                }
                currentViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func deleteBlockedCell(_ sender:Notification) {
        if let i = sender.object as? Int {
            getBlockedTalks()
            talkCellModels.remove(at: i)
            build()
            tableView.deleteRows(at: [IndexPath(row: i, section: 1)], with: .automatic)
        }
    }
    
    //两个按钮显示与隐藏
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation: CGPoint = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        //下滑显示
        if translation.y > 0 {
            showTwoBtn()
        }
        //上滑隐藏
        else if translation.y < 0 {
            hideTwoBtn()
        }
    }
    
    func hideTwoBtn() {
        var goTopBtnHideFrame = goTopBtn.frame
        var publishBtnHideFrame = publishBtn.frame
        goTopBtnHideFrame.origin.y = KScreenHeight
        publishBtnHideFrame.origin.y = KScreenHeight
        UIView.animate(withDuration: 0.5) {
            self.goTopBtn.frame = goTopBtnHideFrame
            self.publishBtn.frame = publishBtnHideFrame
        }
    }
    
    func showTwoBtn() {
        var goTopBtnShowFrame = goTopBtn.frame
        var publishBtnShowFrame = publishBtn.frame
        goTopBtnShowFrame.origin.y = KScreenHeight - (goTopBtnBottomConstant + goTopBtnShowFrame.size.height)
        publishBtnShowFrame.origin.y = KScreenHeight - (publishBtnBottomConstant + publishBtnShowFrame.size.height)
        UIView.animate(withDuration: 0.5) {
            self.goTopBtn.frame = goTopBtnShowFrame
            self.publishBtn.frame = publishBtnShowFrame
        }
    }
    
    func btnAddTarget() {
        publishBtn.addTarget(self, action: #selector(publishBtnClicked), for: .touchUpInside)
        goTopBtn.addTarget(self, action: #selector(goTopBtnClicked), for: .touchUpInside)
    }
    
    @objc func publishBtnClicked() {
        let vc = INSPublishViewController()
        currentViewController()?.present(vc, animated: true, completion: nil)
    }
    
    @objc func goTopBtnClicked() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: Network request
extension INSFindTableVM
{
    func loadTalkData() {
        weak var weakSelf = self
        SVProgressHUD.show()
        getTalks(pageNum: 1).success { (_) in
            var temp = [INSHuDongTalkCellModel]()
            for model in self.talksArray {
                let cellModel = INSHuDongTalkCellModel()
                cellModel.model = model
                temp.append(cellModel)
            }
            weakSelf?.talkCellModels = temp
            SVProgressHUD.dismiss()
            weakSelf?.build()
            weakSelf?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            if let cells = weakSelf?.tableView.visibleCells(in: 1)
            {
                UIView.animate(views: cells, animations: weakSelf!.cellAnim)
            }
            weakSelf?.tableView?.mj_header.endRefreshing()
            weakSelf?.tableView?.mj_footer.endRefreshing()
        }.failed { (_) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
            SVProgressHUD.dismiss()
            weakSelf?.build()
            weakSelf?.reload()
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }
}
