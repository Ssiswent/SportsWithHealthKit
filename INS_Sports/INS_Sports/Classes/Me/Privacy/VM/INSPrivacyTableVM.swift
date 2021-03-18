//
//  INSPrivacyVM.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/28.
//

import UIKit

class INSPrivacyTableVM: BaseTableViewModel {
    func build() {
        let section = BaseTableSectionModel()
        let cellModel = INSPrivacyCellModel()
        section.cellModels = [cellModel]
        self.data = [section]
    }
}
