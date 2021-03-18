//
//  TNRefreshFooter.swift
//  TheNewOne
//
//  Created by 孟子弘 on 2019/4/9.
//  Copyright © 2019年 mzh. All rights reserved.
//

import UIKit

class SSRefreshFooter: MJRefreshFooter {
    
    class func getRefreshFooter(_ refreshHandle:@escaping MJRefreshComponentRefreshingBlock) -> MJRefreshAutoStateFooter{
        let footer = MJRefreshAutoStateFooter.init(refreshingBlock: refreshHandle)
//        footer?.isAutomaticallyRefresh = true
//        footer?.isOnlyRefreshPerDrag = true
        
        return footer!
    }

}
