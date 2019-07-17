//
//  LCYApi.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/2.
//  Copyright © 2019 lcy. All rights reserved.
//

/*
 Moya是一个基于 Alamofire 的更高层网络请求封装抽象层
 Moya安装 需要依赖 Alamofire 库
 
 插件
 PluginType
 
 Moya在初始化Provider的时候可以传入一些插件，Moya库中默认有4个插件。
 1、AccessTokenPlugin 管理AccessToken的插件
 2、CredentialsPlugin 管理认证的插件
 3、NetworkActivityPlugin 管理网络状态的插件
 4、NetworkLoggerPlugin 管理网络log的插件
 自己也可以创建plugin
 
 使用：
 1、首先定义一个 provider，即请求发起对象。往后我们如果要发起网络请求就使用这个 provider。
 2、接着声明一个 enum 来对请求进行明确分类。
 3、最后让这个 enum 实现 TargetType 协议，在这里面定义我们各个请求的 url、参数、header 等信息。
 */

import Moya
import MBProgressHUD
import Result
import HandyJSON

/*
 不带loading的provider
 */
let ApiProvider = MoyaProvider<LCYApi>(requestClosure: timeoutClosure)

/*
 带loading的provider
 */
let ApiLoadingProvider = MoyaProvider<LCYApi>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])

enum LCYApi {
    //搜索热门
    case searchHot
    //相关搜索
    case searchRelative(inputText: String)
    //搜索结果
    case searchResult(argCon: Int, q: String)
    //推荐列表
    case boutiqueList(sexType: Int)
    //专题
    case special(argCon: Int, page: Int)
    //VIP列表
    case vipList
    //订阅列表
    case subscribeList
    //排行列表
    case rankList
    //分类列表
    case cateList
    //漫画列表
    case comicList(argCon: Int, argName: String, argValue: Int, page: Int)
    //猜你喜欢
    case guessLike
    //详情(基本)
    case detailStatic(comicid: Int)
    //详情(实时)
    case detailRealtime(comicid: Int)
    //评论
    case commentList(object_id: Int, thread_id: Int, page: Int)
    //章节内容
    case chapter(chapter_id: Int)
}

extension LCYApi: TargetType {
    
    var baseURL: URL {
        return NSURL.init(string: "http://app.u17.com/v3/appV3_3/ios/phone")! as URL
    }
    
    var path: String {
        switch self {
        case .searchHot: return "search/hotkeywordsnew"
        case .searchRelative: return "search/relative"
        case .searchResult: return "search/searchResult"
            
        case .boutiqueList: return "comic/boutiqueListNew"
        case .special: return "comic/special"
        case .vipList: return "list/vipList"
        case .subscribeList: return "list/newSubscribeList"
        case .rankList: return "rank/list"
            
        case .cateList: return "sort/mobileCateList"
            
        case .comicList: return "list/commonComicList"
            
        case .guessLike: return "comic/guessLike"
            
        case .detailStatic: return "comic/detail_static_new"
        case .detailRealtime: return "comic/detail_realtime"
        case .commentList: return "comment/list"
            
        case .chapter: return "comic/chapterNew"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    //这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .searchRelative(let inputText):
            parmeters["inputText"] = inputText
            
        case .searchResult(let argCon, let q):
            parmeters["argCon"] = argCon
            parmeters["q"] = q
            
        case .boutiqueList(let sexType):
            parmeters["sexType"] = sexType
            
        case .special(let argCon,let page):
            parmeters["argCon"] = argCon
            parmeters["page"] = max(1, page)
            
        case .comicList(let argCon, let argName, let argValue, let page):
            parmeters["argCon"] = argCon
            if argName.count > 0 { parmeters["argName"] = argName }
            parmeters["argValue"] = argValue
            parmeters["page"] = max(1, page)
            
        case .detailStatic(let comicid),
             .detailRealtime(let comicid):
            parmeters["comicid"] = comicid
            
        case .commentList(let object_id, let thread_id, let page):
            parmeters["object_id"] = object_id
            parmeters["thread_id"] = thread_id
            parmeters["page"] = page
            
        case .chapter(let chapter_id):
            parmeters["chapter_id"] = chapter_id
            
        default: break
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    //在请求头内添加公共请求参数
    var headers: [String : String]? {
        return nil
    }
}

// MARK: - 请求超时closure --------
let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<LCYApi>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 60
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

// MARK: - Moya自带插件 -----------
let LoadingPlugin = NetworkActivityPlugin { (type, target) in
    guard let vc = topVC else { return }
    switch type {
    case .began:
        MBProgressHUD.hide(for: vc.view, animated: false)
        MBProgressHUD.showAdded(to: vc.view, animated: true)
    case .ended:
        MBProgressHUD.hide(for: vc.view, animated: true)
    }
}

extension MoyaProvider {
    /*
     当有返回值的方法未得到接收和使用时通常会出现"Result of call to "getSome()" is unused"的提示
     虽然不会报错，但是影响美观，加上@discardableResult就可以取消这种警告
     */
    @discardableResult
    /*
     <T>泛型函数语法
     <T: HandyJSON>在下面的方法的使用表示model这个参数的类型是HandyJSON类型或者继承自它的
     */
    open func request<T: HandyJSON>(_ target: Target,
                      model: T.Type,
                      completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        
        return request(target, completion: { (result) in
            guard completion != nil else { return }
            
            /*
            Moya 会将 Alamofire 成功或失败的响应包裹在 Result 枚举中返回
                .success(Moya.Response)：成功的情况。我们可以从 Moya.Response 中得到返回数据（data）和状态（status ）
             .failure(MoyaError)：失败的情况。这里的失败指的是服务器没有收到请求（例如可达性/连接性错误）或者没有发送响应（例如请求超时）。我们可以在这里设置个延迟请求，过段时间重新发送请求。

             */
            switch result {
            case let .success(response):
                let statusCode = response.statusCode // 响应状态码：200, 401, 500...
                let data = response.data // 响应数据
                
                
                print("请求成功返回数据\n \(statusCode) \(data)")
                
            case let .failure(error):
                //错误处理....
                
                print("请求错误\n \(error)")
                
                break
            }
            
            
            guard let resultData = try? result.value?.mapModel(LCYResponseData<T>.self) else {
                completion!(nil)
                return
            }
            completion!(resultData.data?.returnData)
        })
        
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            //json反序列化失败，抛出异常
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}
