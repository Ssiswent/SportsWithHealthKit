//
//  TNRefreshHeader.swift
//  TheNewOne
//
//  Created by 孟子弘 on 2019/4/9.
//  Copyright © 2019年 mzh. All rights reserved.
//

import UIKit
import MJRefresh
class SSRefreshHeader: MJRefreshHeader {
    
    class func getRefreshHeader(_ refreshHandle:@escaping MJRefreshComponentbeginRefreshingCompletionBlock) -> MJRefreshStateHeader{
        let header = MJRefreshStateHeader.init(refreshingBlock: refreshHandle)
        
        return header!
    }

}
