//
//  LCYModel.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/4.
//  Copyright © 2019 lcy. All rights reserved.
//

import HandyJSON

struct LCYReturnData<T: HandyJSON>: HandyJSON {
    var message:String?
    var returnData: T?
    var stateCode: Int = 0
}

struct LCYResponseData<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var data: LCYReturnData<T>?
}

/*
 currentRequest = ApiProvider.request(LCYApi.searchRelative(inputText: text), model: [LCYSearchItemModel].self) { (returnData) in
 }
 这种[Model].self数组作为参数的需要Array继承自HandyJson
 */
extension Array: HandyJSON{}

struct LCYImageModel: HandyJSON {
    var location: String?
    var image_id: Int = 0
    var width: Int = 0
    var height: Int = 0
    var total_tucao: Int = 0
    var webp: Int = 0
    var type: Int = 0
    var img05: String?
    var img50: String?
}

struct LCYChapterModel: HandyJSON {
    var status: Int = 0
    var chapter_id: Int = 0
    var type: Int = 0
    var image_list: [LCYImageModel]?
}

struct LCYAuthorModel: HandyJSON {
    var id: Int = 0
    var avatar: String?
    var name: String?
}

struct LCYClassifyTagModel: HandyJSON {
    var name: String?
    var argName: String?
    var argVal: Int = 0
}

struct LCYComicStaticModel: HandyJSON {
    var name: String?
    var comic_id: Int = 0
    var short_description: String?
    var accredit: Int = 0
    var cover: String?
    var is_vip: Int = 0
    var type: Int = 0
    var ori: String?
    var theme_ids: [String]?
    var series_status: Int = 0
    var last_update_time: TimeInterval = 0
    var description: String?
    var cate_id: String?
    var status: Int = 0
    var thread_id: Int = 0
    var last_update_week: String?
    var wideCover: String?
    var classifyTags: [LCYClassifyTagModel]?
    var is_week: Bool = false
    var comic_color: String?
    var author: LCYAuthorModel?
    var is_dub: Bool = false
}

struct LCYImHightModel: HandyJSON {
    var height: Int = 0
    var width: Int = 0
}

struct LCYChapterStaticModel: HandyJSON {
    var chapter_id: Int = 0
    var name: String?
    var image_total: Int = 0
    var type: Int = 0
    var price:String?
    var size: Int32 = 0
    var pass_time: TimeInterval = 0
    var release_time: TimeInterval = 0
    var zip_high_webp: Int = 0
    var is_new: Bool = false
    var has_locked_image: Bool = false
    var imHightArr: [[LCYImHightModel]]?
    var countImHightArr: Int = 0
}

struct LCYOtherWorkModel: HandyJSON {
    var comicId: Int = 0
    var coverUrl: String?
    var name: String?
    var passChapterNum: Int = 0
}

struct LCYDetailStaticModel: HandyJSON {
    var comic: LCYComicStaticModel?
    var chapter_list: [LCYChapterStaticModel]? //目录
    var otherWorks: [LCYOtherWorkModel]?
}

struct LCYComicRealtimeModel: HandyJSON {
    var comic_id: Int = 0
    var user_id: Int = 0
    var status: Int = 0
    var click_total: String?
    var total_ticket: String?
    var comment_total: String?
    var total_tucao: String?
    var favorite_total: String?
    var gift_total: String?
    var monthly_ticket: String?
    var vip_discount: Double = 0
    var is_vip_free: Bool = false
    var is_free: Bool = false
    var is_vip_buy: Bool = false
    var is_auto_buy: Bool = false
}

struct LCYChapterRealtimeModel: HandyJSON {
    var vip_images: Int = 0
    var is_view: Bool = false
    var chapter_id: Int = 0
    var buyed: Bool = false
    var buy_price: String?
    var read_state: Int = 0
    var is_free: Bool = false
}

struct LCYDetailRealtimeModel: HandyJSON {
    var comic: LCYComicRealtimeModel?
    var chapter_list: [LCYChapterRealtimeModel]?
}

struct LCYGuessLikeModel: HandyJSON {
    var normal: Bool = false
    var last_modified: Int = 0
    var comics: [LCYComicModel]?
}

struct LCYLevelModel: HandyJSON {
    var aLCYm_size: CGFloat = 0
    var exp_speed: Float = 0
    var favorite_num: Int = 0
    var level: Int = 0
    var max: Int = 0
    var min_exp: Int = 0
    var ticket: Int = 0
    var wage: Int = 0
}

struct LCYCommentModel: HandyJSON {
    var cate: Int = 0
    var color: String?
    var comic_author: Int = 0
    var comment_from: String?
    var comment_id: Int = 0
    var content: String?
    var content_filter: String?
    var create_time: TimeInterval = 0
    var create_time_str: String?
    var exp: Float = 0
    var face: String?
    var face_type: Int = 0
    var floor: Int = 0
    var gift_img: String?
    var gift_num: Int = 0
    var group_admin: Bool = false
    var group_author: Bool = false
    var group_custom: Bool = false
    var group_user: Bool = false
    var id: Int = 0
    var imageList: [Any]?
    var ip: String?
    var is_choice: Bool = false
    var is_delete: Bool = false
    var is_lock: Bool = false
    var is_up: Bool = false
    var level: LCYLevelModel?
    var likeCount: Int = 0
    var likeState: Int = 0
    var nickname: String?
    var online_time: TimeInterval = 0
    var sex: String?
    var ticketNum: Int = 0
    var title: String?
    var total_reply: Int = 0
    var user_id: Int = 0
    var vip_exp: Int = 0
}

struct LCYCommentListModel: HandyJSON {
    var commentCount: Int = 0
    var commentList: [LCYCommentModel]?
    var hasMore: Bool = false
    var objectId: Int = 0
    var objectType: String?
    var page: Int = 0
    var pageCount: Int = 0
    var serverNextPage: Int = 0
}

struct LCYSearchItemModel: HandyJSON {
    var comic_id: Int = 0
    var name: String?
    var bgColor: String?
}

struct LCYSearchResultModel: HandyJSON {
    var comicNum: Int = 0
    var hasMore: Bool = false
    var page: Int = 0
    var comics: [LCYComicModel]?
}

struct LCYHotItemsModel: HandyJSON {
    var hotItems: [LCYSearchItemModel]?
    var defaultSearch: String?
}

struct LCYExtModel: HandyJSON {
    var key: String?
    var val: String?
}

struct LCYComicModel: HandyJSON {
    var comicId: Int = 0
    var comic_id: Int = 0
    var cate_id: Int = 0
    var name: String?
    var title: String?
    var itemTitle: String?
    var subTitle: String?
    var author_name: String?
    var author: String?
    var cover: String?
    var wideCover: String?
    var content: String?
    var description: String?
    var short_description: String?
    var affiche: String?
    var tag: String?
    var tags: [String]?
    var group_ids: String?
    var theme_ids: String?
    var url: String?
    var read_order: Int = 0
    var create_time: TimeInterval = 0
    var last_update_time: TimeInterval = 0
    var deadLine: TimeInterval = 0
    var new_comic: Bool = false
    var chapter_count: Int = 0
    var cornerInfo: Int = 0
    var linkType: Int = 0
    var specialId: Int = 0
    var specialType: Int = 0
    var argName: String?
    var argValue: Int = 0
    var argCon: Int = 0
    var flag: Int = 0
    var conTag: Int = 0
    var isComment: Bool = false
    var is_vip: Bool = false
    var isExpired: Bool = false
    var canToolBarShare: Bool = false
    var ext: [LCYExtModel]?
}

enum LCYComicType: Int, HandyJSONEnum {
    case none = 0
    case update = 3
    case thematic = 5
    case animation = 9
    case billboard = 11
}

struct LCYSpinnerModel: HandyJSON {
    var argCon: Int = 0
    var name: String?
    var conTag: String?
    
}

struct LCYDefaultParametersModel: HandyJSON {
    var defaultSelection: Int = 0
    var defaultArgCon: Int = 0
    var defaultConTagType: String?
}

struct LCYComicListModel: HandyJSON {
    var comicType: LCYComicType = .none
    var canedit: Bool = false
    var sortId: Int = 0
    var titleIconUrl: String?
    var newTitleIconUrl: String?
    var description: String?
    var itemTitle: String?
    var argCon: Int = 0
    var argName: String?
    var argValue: Int = 0
    var argType: Int = 0
    var comics:[LCYComicModel]?
    var maxSize: Int = 0
    var canMore: Bool = false
    var hasMore: Bool = false
    var spinnerList: [LCYSpinnerModel]?
    var defaultParameters: LCYDefaultParametersModel?
    var page: Int = 0
}

struct LCYGalleryItemModel: HandyJSON {
    var id: Int = 0
    var linkType: Int = 0
    var cover: String?
    var ext: [LCYExtModel]?
    var title: String?
    var content: String?
}

struct LCYTextItemModel: HandyJSON {
    var id: Int = 0
    var linkType: Int = 0
    var cover: String?
    var ext: [LCYExtModel]?
    var title: String?
    var content: String?
}


struct LCYBoutiqueListModel: HandyJSON {
    var galleryItems: [LCYGalleryItemModel]?
    var textItems: [LCYTextItemModel]?
    var comicLists: [LCYComicListModel]?
    var editTime: TimeInterval = 0
}

struct LCYVipListModel: HandyJSON {
    var newVipList: [LCYComicListModel]?
}

struct LCYSubscribeListModel: HandyJSON {
    var newSubscribeList: [LCYComicListModel]?
}

struct LCYRankingModel: HandyJSON {
    var argCon: Int = 0
    var argName: String?
    var argValue: Int = 0
    var canEdit: Bool = false
    var cover: String?
    var isLike: Bool = false
    var sortId: Int = 0
    var sortName: String?
    var title: String?
    var subTitle: String?
    var rankingType: Int = 0
}

struct LCYRankinglistModel: HandyJSON {
    var rankinglist: [LCYRankingModel]?
}

struct LCYTabModel: HandyJSON {
    var argName: String?
    var argValue: Int = 0
    var argCon: Int = 0
    var tabTitle: String?
}

struct LCYTopExtra: HandyJSON {
    var title: String?
    var tabList: [LCYTabModel]?
}

struct LCYTopModel: HandyJSON {
    var sortId: Int = 0
    var sortName: String?
    var cover: String?
    var extra: LCYTopExtra?
    var uiWeight: Int = 0
}

struct LCYCateListModel: HandyJSON {
    var recommendSearch: String?
    var rankingList:[LCYRankingModel]?
    var topList:[LCYTopModel]?
}
