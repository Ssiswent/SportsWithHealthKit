//
//  FlamingoNet.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/24/20.
//

import Foundation
import Alamofire

let baseUrl = "http://118.31.110.249:81"
let baseUrl1 = "http://123.56.163.99:81"
enum Project: String {
    case chess = "chess"
    case blockChain = "blockchain"
    case futures = "futures"
    case bitte = "bitte"
    case BCH = "BCH"
    case economic = "economic"
    case sport1 = "sport1"
}

let AppBundleId: String = "com.LYG.Test"
var userKey: String? = "f5f3dbae440011eb671b2550242ac110003"
public func GetAppNetWorkSecurityWords(bundleId: String, key: String) -> (String) {
    let date = NSDate()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyyyMMdd"
    let strNowTime = timeFormatter.string(from: date as Date) as String
    let md5String = GHDateTools.generateMD5String(from: "\(bundleId)" + "\(strNowTime)")
    return md5String + key
}

class API {
    ///场馆列表 GET
    static let getStadiums = baseUrl + "/stadium/selectStadium/"
    
    ///注册 POST
    static let register = baseUrl + "/system/register/"
    ///登录 GET
    static let login = baseUrl + "/system/login/"
    ///发送验证码 POST
    static let sendCode = baseUrl + "/system/sendCode/"
    ///发送图形验证码 GET
    static let sendPicCode = baseUrl + "/system/sendVerify"
    ///修改密码 POST
    static let resetPwd = baseUrl + "/system/resetPassword/"
    ///获取关注/粉丝数量 GET
    static let getFollowCount = baseUrl + "/user/follow/getUserFollowCount/"
    ///刷新用户信息 POST
    static let refreshUserInfo = baseUrl + "/user/personal/queryUser/"
    ///修改个人信息 POST
    static let changeUserInfo = baseUrl + "/user/personal/updateUser/"
    ///获取推荐用户列表 GET
    static let getRecommandUserList = baseUrl + "/user/follow/getRecommandUserList/"
    ///根据userId获取说说列表  POSTJSON
    static let getUserTalkList = baseUrl + "/user/talk/getTalkList/155/"
    ///获取推荐说说列表 GET
    static let getRecommendTalkList = baseUrl + "/user/talk/getRecommandTalk/"
    ///获取新闻快讯 GET
    static let getQuickNews = baseUrl + "/news/getNewListByProject.do/"
    ///获取说说评论列表 POSTJSON
    static let getTalkComment = baseUrl + "/user/talk/getCommentList/"
    ///根据userId获取评论列表 GET
    static let getCommentByUserId = baseUrl + "/user/talk/getDiscussByUserId/"
    ///发布说说 POST
    static let publishTalk = baseUrl + "/user/talk/publishTalk/"
    ///获取签到信息 GET
    static let getSignList = baseUrl + "/user/sign/getSignList"
    ///签到 POST
    static let checkIn = baseUrl + "/user/sign/signNow/"
    ///今天是否签到 GET
    static let ifCheckedIn = baseUrl + "/user/sign/hasSign/"
    ///是否关注该用户 GET
    static let ifFollowed = baseUrl + "/user/follow/isFollow/"
    ///关注用户 POST
    static let followUser = baseUrl + "/user/follow/follow/"
    ///获取用户关注/粉丝列表 GET
    static let getFollowOrFansList = baseUrl + "/user/follow/getUserFollowList/"
    ///点赞说说 POST type = 2
    static let likeTalk = baseUrl + "/user/userTalk/userTalkOperation"
    ///评论说说 POST
    static let commentTalk = baseUrl + "/user/talk/commentTalk/"
    ///举报说说 POST
    static let reportTalk = baseUrl + "/user/talk/reportTalk/"
    ///数据日历 GET
    static let calendaNews = baseUrl + "/admin/getFinanceCalender/"
    
    ///上传图片
    static let uploadImg = "http://image.yysc.online/upload"
    
    ///发推送
    static let sendNotifacation = baseUrl + "/jiGuang/sendMsg"
    ///屏蔽说说或用户 POST type 1-用户 2-说说
    static let blockTalk = baseUrl + "/user/personal/block/"
    
    ///注销账户
    static let logOff = baseUrl + "/user/personal/deleteByUserId"
    
    ///期货数据
    static let futuresData = "http://data.api51.cn/apis/integration/rank/?market_type=commodity&limit=33&order_by=desc&fields=prod_name%2Cprod_code%2Clast_px%2Cpx_change%2Cpx_change_rate%2Chigh_px%2Clow_px%2Cupdate_time&token=3f39051e89e1cea0a84da126601763d8"
    
    ///货币数据
    static let cashData =
        "http://data.api51.cn/apis/integration/rank/?market_type=cryptocurrency&limit=13&order_by=desc&fields=prod_name%2Cprod_code%2Clast_px%2Cpx_change%2Cpx_change_rate%2Chigh_px%2Clow_px%2Cupdate_time&token=3f39051e89e1cea0a84da126601763d8"
}

class SSNetwork {
    static let shared = SSNetwork()
    private var taskQueue = [SSNetworkRequest]()
    
    let headers: HTTPHeaders = ["Authorization": "token \(GetAppNetWorkSecurityWords(bundleId: AppBundleId, key: userKey!))"]

    fileprivate func request(url: String,
                             method: HTTPMethod = .get,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding? = URLEncoding.default,
                             headers: HTTPHeaders? = nil) -> SSNetworkRequest {
        
        let task = SSNetworkRequest()

        task.request = AF.request(url,
                                  method: method,
                                  parameters: parameters,
                                  encoding: encoding!,
                                  headers: headers).responseJSON { [weak self] response in
                                    task.handleResponse(response: response)
                                    if let index = self?.taskQueue.firstIndex(of: task) {
                                        self?.taskQueue.remove(at: index)
                                    }
                                  }
        taskQueue.append(task)
        return task
    }
    
    fileprivate func upload(url: String,
                            image: UIImage,
                            compressionQuality: CGFloat? = 0.8) -> SSNetworkRequest {
        
        let task = SSNetworkRequest()
        
        task.request = AF.upload(multipartFormData: { (multipartData) in
            multipartData.append(image.jpegData(compressionQuality: compressionQuality!)!, withName: "name", fileName: "file.png", mimeType: "image/png")
        }, to: url).responseString(completionHandler: { [weak self] response in
            task.handleStringResponse(response: response)
            if let index = self?.taskQueue.firstIndex(of: task) {
                self?.taskQueue.remove(at: index)
            }
        })
        return task
    }
    
}

extension SSNetwork {
    func GET(URLStr: String, params: Parameters? = nil) -> SSNetworkRequest {
        request(url: URLStr, method: .get, parameters: params, headers: headers)
    }
    
    func POST(URLStr: String, params: Parameters? = nil) -> SSNetworkRequest {
        request(url: URLStr, method: .post, parameters: params, headers: headers)
    }
    
    ///查询条件为JSON字符串
    func POSTJSON(URLStr: String, params: Parameters? = nil) -> SSNetworkRequest {
        request(url: URLStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
    }
    
    /// 上传图片
    /// - Parameters:
    ///   - URLStr: URL
    ///   - image: 要上传的图片
    ///   - compressionQuality: 图片压缩比例(默认为0.8)
    func UPLOADImg(URLStr: String, image: UIImage, compressionQuality: CGFloat? = 0.8) -> SSNetworkRequest {
        upload(url: URLStr, image: image, compressionQuality: compressionQuality)
    }
    
    func PUT(URLStr: String, params: Parameters) -> SSNetworkRequest {
        request(url: URLStr, method: .put, parameters: params, headers: headers)
    }
    
    func PUTJSON(URLStr: String, params: Parameters) -> SSNetworkRequest {
        request(url: URLStr, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
    }
}

class SSNetworkRequest: Equatable {
    static func == (lhs: SSNetworkRequest, rhs: SSNetworkRequest) -> Bool {
        return lhs.request?.id == rhs.request?.id
    }
    
    typealias SuccessBlock = (_ response: Any) -> Void
    typealias FailureBlock = (_ error: Any) -> Void
    
    /// Alamofire.DataRequest
    var request: DataRequest?
    
    /// request response callback
    private var successHandler: SuccessBlock?
    /// request failed callback
    private var failedHandler: FailureBlock?
    
    // MARK: Handler
    
    /// Handle request response
    func handleResponse(response: AFDataResponse<Any>) {
        switch response.result {
        case .failure(let error):
            if let closure = failedHandler {
                closure(error.localizedDescription)
            }
        case .success(let JSON):
            if let closure = successHandler {
                closure(JSON)
            }
        }
        clearReference()
    }
    
    /// Handle request  string response
    func handleStringResponse(response: AFDataResponse<String>) {
        switch response.result {
        case .failure(let error):
            if let closure = failedHandler {
                closure(error.localizedDescription)
            }
        case .success(let string):
            if let closure = successHandler {
                closure(string)
            }
        }
        clearReference()
    }
    
    // MARK: Callback
    
    /// Adds a handler to be called once the request has finished.
    public func success(_ closure: @escaping SuccessBlock) -> Self {
        successHandler = closure
        return self
    }
    
    /// Adds a handler to be called once the request has finished.
    @discardableResult
    public func failed(_ closure: @escaping FailureBlock) -> Self {
        failedHandler = closure
        return self
    }
    
    /// Free memory
    func clearReference() {
        successHandler = nil
        failedHandler = nil
    }
}
