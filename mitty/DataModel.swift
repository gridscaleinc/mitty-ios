//
//  Model.swift
//  mitty
//
//  Created by gridscale on 2016/10/30.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

/// 活動
class Activity {
    
}

///
/// イベント情報
class Event {
    
    public var eventId: String! = ""
    public var title: String = ""
    public var price: Int = 0
    public var imageUrl: String = ""
    public var place : String = ""
    
    
    // YYYY-MM-DD
    public var startDate: String = ""
    public var startTime: String = ""
    
    // YYYY-MM-DD
    public var endDate : String = ""
    public var endTime : String = ""
    
    public var likes : Int = 10
    
}


/// 連絡先
class SocialContactInfo {
    public var mittyId = ""
    public var imageUrl = ""
    public var name = ""
    
    
    
}

class LineId : SocialContactInfo {
    
}

class WeChat : SocialContactInfo {
    
}

class TwitterId : SocialContactInfo {
    
}

class MailAddress : SocialContactInfo {
    
}

/// 予定
class SchedulePlan {
    
}

/// 島（グループ）
class Island {
    public var islandId = ""
    public var islandName = ""
    public var type = "private"
    
}

// セッション
class Session {
    
}

/// 面会
class Meetup : Activity {
    
}

/// 会議、集まり
class Meeting : Activity {
    
}

/// 展示会
class Exhibition : Event {
    
}

/// 飲み会
class DrinkingParty : Event {
    
}

/// 旅程
class Journey : Activity {
    
}

///移動
class Moving : Activity {
    
}

/// 交通機関
class TransportationFacility {
    
}

// 住民、生活者
class Inhabitant {
    
}

///個人情報
class PersonalInfo {
    
    
}

/// 名刺
class NameCard : PersonalInfo {
    
}

/// パスポート
class Passport : PersonalInfo {
    
}

/// 運転免許証
class DrivingLicense : PersonalInfo {
    
}

/// 健康保険証
class HealthInsuranceCertificate : PersonalInfo {
    
}

/// 出現情報
class Presence {
    
}

/// ブース
class Buss {
    
}

/// 宣伝
class Promotion {
    
}

/// 業者
class BusinessPartner {
    
}

/// 宣伝者
class Promoter : BusinessPartner {
    
}

/// 会社
class Company {
    
}

/// 旅行代理店
class TravelAgent : BusinessPartner {
    
}

/// リソース
class Resource {
    
}

/// 便
class Flight : Resource {
    
}

/// 席情報
class SeatInfo {
    
}

/// 発言
class Talk {
    
    public var mittyId = ""
    public var avatarIcon = ""
    public var familyName = ""
    public var speaking = ""
    
}

/// 会話
class Conversation {
    
}

/// 島住民会議
class IslandConversation : Conversation {
    
}

/// 招待
class Invitation {
    
}

/// 紹介
class Intruduce {
    
}
