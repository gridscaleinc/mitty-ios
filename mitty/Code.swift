//
//  Code.swift
//  mitty
//
//  Created by gridscale on 2017/08/17.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

/// コードは多言語を対応すること念頭に置いた、DB値と画面に表示する値の対応関係を表した
/// モデルクラス。
public struct Code {
    var type: String!
    var locale: String?
    var key: String!
    var value: String!
    var remarks: String?

    public init(t: String, l: String?, k: String, v: String, r: String?) {
        self.type = t
        self.locale = l
        self.key = k
        self.value = v
        self.remarks = r

    }
}

public typealias CodeBase = [String: [String: Code]]


/// <#Description#>
public var mittyCodes: CodeBase = [

    // 英語圏
    "Gendre": [
        "Male": Code(t: "Gendre", l: "en_xx", k: "Male", v: "Male", r: "A man"),
        "Femal": Code(t: "Gendre", l: "en_xx", k: "Female", v: "Female", r: "A woman"),
        "Secret": Code(t: "Gendre", l: "en_xx", k: "Secret", v: "Secret", r: "Keep gendre as scret"),
    ],
    // 日本語
    "Gendre_ja_jp": [
        "Male": Code(t: "Gendre", l: "ja_jp", k: "Male", v: "男性", r: "男の人"),
        "Female": Code(t: "Gendre", l: "ja_jp", k: "Female", v: "女性", r: "女の人"),
        "Secret": Code(t: "Gendre", l: "ja_jp", k: "Secret", v: "秘密", r: "公開したくないから"),
    ],
    // 中国語(本土)
    "Gendre_zh_cn": [
        "Male": Code(t: "Gendre", l: "zh_cn", k: "Male", v: "男", r: "男人"),
        "Femal": Code(t: "Gendre", l: "zh_cn", k: "Female", v: "女", r: "女人"),
        "Secret": Code(t: "Gendre", l: "zh_cn", k: "Secret", v: "秘密", r: "不想公开"),
    ],

    // 英語圏
    "Age": [
        "Underage": Code(t: "Age", l: "en_xx", k: "Underage", v: "Underage", r: "A person who is underage"),
        "Yuang": Code(t: "Age", l: "en_xx", k: "Yuang", v: "Yuang", r: "A yuang man or woman"),
        "Middle": Code(t: "Age", l: "en_xx", k: "Middle", v: "Middle", r: "A midle aged person"),
        "Old": Code(t: "Age", l: "en_xx", k: "Old", v: "Old", r: "An oldman or woman"),
        "Secret": Code(t: "Age", l: "en_xx", k: "Secret", v: "Secret", r: "Keep age as scret"),
    ],

    // 日本語
    "Age_ja_jp": [
        "Underage": Code(t: "Age", l: "ja_jp", k: "Underage", v: "未成年", r: "A person who is underage"),
        "Yuang": Code(t: "Age", l: "ja_jp", k: "Yuang", v: "若い人", r: "A yuang man or woman"),
        "Middle": Code(t: "Age", l: "ja_jp", k: "Middle", v: "おっさん", r: "A midle aged person"),
        "Old": Code(t: "Age", l: "ja_jp", k: "Old", v: "年寄り", r: "An oldman or woman"),
        "Secret": Code(t: "Age", l: "ja_jp", k: "Secret", v: "内緒", r: "Keep age as scret"),
    ],

    // 中国語
    "Age_zh_cn": [
        "Underage": Code(t: "Age", l: "zh_cn", k: "Underage", v: "未成年", r: "A person who is underage"),
        "Yuang": Code(t: "Age", l: "zh_cn", k: "Yuang", v: "年青人", r: "A yuang man or woman"),
        "Middle": Code(t: "Age", l: "zh_cn", k: "Middle", v: "中年人", r: "A midle aged person"),
        "Old": Code(t: "Age", l: "zh_cn", k: "Old", v: "老人", r: "An oldman or woman"),
        "Secret": Code(t: "Age", l: "zh_cn", k: "Secret", v: "最高机密", r: "Keep age as scret"),

    ],

    "Appearance": [
        "Fashionable": Code(t: "Appearance", l: "en_xx", k: "Fashionable", v: "Fashionable", r: "Trendy and fashionable"),
        "GoodLook": Code(t: "Appearance", l: "en_xx", k: "GoodLook", v: "Good Look", r: "Handsome or beautiful"),
        "Chubby": Code(t: "Appearance", l: "en_xx", k: "Chubby", v: "Chubby", r: "Chubby or plump"),
        "Slender": Code(t: "Appearance", l: "en_xx", k: "Slender", v: "Slender", r: "Thiny body"),
    ],

    "Appearance_ja_jp": [

        "Fashionable": Code(t: "Appearance", l: "ja_jp", k: "Fashionable", v: "お洒落", r: "Trendy and fashionable"),
        "GoodLook": Code(t: "Appearance", l: "ja_jp", k: "GoodLook", v: "容姿端麗", r: "Handsome or beautiful"),
        "Chubby": Code(t: "Appearance", l: "ja_jp", k: "Chubby", v: "ぽちゃり", r: "Chubby or plump"),
        "Slender": Code(t: "Appearance", l: "ja_jp", k: "Slender", v: "細身", r: "Thiny body"),
    ],
    "Appearance_zh_cn": [

        "Fashionable": Code(t: "Appearance", l: "zh_cn", k: "Fashionable", v: "时髦", r: "Trendy and fashionable"),
        "GoodLook": Code(t: "Appearance", l: "zh_cn", k: "GoodLook", v: "容貌端正", r: "Handsome or beautiful"),
        "Chubby": Code(t: "Appearance", l: "zh_cn", k: "Chubby", v: "有点发福", r: "Chubby or plump"),
        "Slender": Code(t: "Appearance", l: "zh_cn", k: "Slender", v: "身材修长", r: "Thiny body"),
    ],

    "Occupation": [
        "001": Code(t: "Occupation", l: "en_xx", k: "001", v: "IT", r: ""),
        "002": Code(t: "Occupation", l: "en_xx", k: "002", v: "Tourism", r: ""),
        "003": Code(t: "Occupation", l: "en_xx", k: "003", v: "Food", r: ""),
        "004": Code(t: "Occupation", l: "en_xx", k: "004", v: "Finance", r: ""),
        "005": Code(t: "Occupation", l: "en_xx", k: "005", v: "Media", r: ""),
        "006": Code(t: "Occupation", l: "en_xx", k: "006", v: "Communication", r: ""),
        "007": Code(t: "Occupation", l: "en_xx", k: "007", v: "Transportation", r: ""),
        "008": Code(t: "Occupation", l: "en_xx", k: "008", v: "Aviation", r: ""),
        "009": Code(t: "Occupation", l: "en_xx", k: "009", v: "Shipping", r: ""),
        "010": Code(t: "Occupation", l: "en_xx", k: "010", v: "Agriculture", r: ""),
        "011": Code(t: "Occupation", l: "en_xx", k: "011", v: "Manufacture", r: ""),
        "012": Code(t: "Occupation", l: "en_xx", k: "012", v: "Construction", r: ""),
    ],
    "Occupation_ja_jp": [
        "001": Code(t: "Occupation", l: "ja_jp", k: "001", v: "IT", r: ""),
        "002": Code(t: "Occupation", l: "ja_jp", k: "002", v: "観光", r: ""),
        "003": Code(t: "Occupation", l: "ja_jp", k: "003", v: "飲食", r: ""),
        "004": Code(t: "Occupation", l: "ja_jp", k: "004", v: "金融", r: ""),
        "005": Code(t: "Occupation", l: "ja_jp", k: "005", v: "メディア", r: ""),
        "006": Code(t: "Occupation", l: "ja_jp", k: "006", v: "通信", r: ""),
        "007": Code(t: "Occupation", l: "ja_jp", k: "007", v: "交通", r: ""),
        "008": Code(t: "Occupation", l: "ja_jp", k: "008", v: "航空", r: ""),
        "009": Code(t: "Occupation", l: "ja_jp", k: "009", v: "海運", r: ""),
        "010": Code(t: "Occupation", l: "ja_jp", k: "010", v: "農業", r: ""),
        "011": Code(t: "Occupation", l: "ja_jp", k: "011", v: "製造", r: ""),
        "012": Code(t: "Occupation", l: "ja_jp", k: "012", v: "建設", r: ""),
    ],
    "Hobby": [
        "001": Code(t: "Hobby", l: "en_xx", k: "001", v: "Fishing", r: ""),
        "002": Code(t: "Hobby", l: "en_xx", k: "002", v: "Game", r: ""),
        "003": Code(t: "Hobby", l: "en_xx", k: "003", v: "Travel", r: ""),
        "004": Code(t: "Hobby", l: "en_xx", k: "004", v: "Sunday Carpenter", r: ""),
        "005": Code(t: "Hobby", l: "en_xx", k: "005", v: "Reading", r: ""),
        "006": Code(t: "Hobby", l: "en_xx", k: "006", v: "Music", r: ""),
        "007": Code(t: "Hobby", l: "en_xx", k: "007", v: "Gardening", r: ""),
        "008": Code(t: "Hobby", l: "en_xx", k: "008", v: "Exercise", r: ""),
        "009": Code(t: "Hobby", l: "en_xx", k: "009", v: "Art", r: "")
    ],
    "Hobby_ja_jp": [
        "001": Code(t: "Hobby", l: "ja_jp", k: "001", v: "釣り", r: ""),
        "002": Code(t: "Hobby", l: "ja_jp", k: "002", v: "ゲーム", r: ""),
        "003": Code(t: "Hobby", l: "ja_jp", k: "003", v: "旅行", r: ""),
        "004": Code(t: "Hobby", l: "ja_jp", k: "004", v: "日曜大工", r: ""),
        "005": Code(t: "Hobby", l: "ja_jp", k: "005", v: "読書", r: ""),
        "006": Code(t: "Hobby", l: "ja_jp", k: "006", v: "音楽", r: ""),
        "007": Code(t: "Hobby", l: "ja_jp", k: "007", v: "ガーデニング", r: ""),
        "008": Code(t: "Hobby", l: "ja_jp", k: "008", v: "運動", r: ""),
        "009": Code(t: "Hobby", l: "ja_jp", k: "009", v: "美術", r: ""),
        "010": Code(t: "Hobby", l: "ja_jp", k: "010", v: "書道", r: ""),
        "011": Code(t: "Hobby", l: "ja_jp", k: "011", v: "陶器", r: ""),
        "012": Code(t: "Hobby", l: "ja_jp", k: "012", v: "クレクション", r: "")
    ],
    
    "Constellation" : [
        "01": Code(t: "Constellation", l: "en_xx", k: "01", v: "♈️ Aries", r: ""),
        "02": Code(t: "Constellation", l: "en_xx", k: "02", v: "♉️ Taurus", r: ""),
        "03": Code(t: "Constellation", l: "en_xx", k: "03", v: "♊️ Gemini", r: ""),
        "004":Code(t: "Constellation", l: "en_xx", k: "04", v: "♋️ Cancer", r: ""),
        "05": Code(t: "Constellation", l: "en_xx", k: "05", v: "♌️ Leo", r: ""),
        "06": Code(t: "Constellation", l: "en_xx", k: "06", v: "♍️ Virgo", r: ""),
        "07": Code(t: "Constellation", l: "en_xx", k: "07", v: "♎️ Libra", r: ""),
        "08": Code(t: "Constellation", l: "en_xx", k: "08", v: "♏️ Scorpius", r: ""),
        "09": Code(t: "Constellation", l: "en_xx", k: "09", v: "♐️ Sagittarius", r: ""),
        "10": Code(t: "Constellation", l: "en_xx", k: "10", v: "♑️ Capriconus", r: ""),
        "11": Code(t: "Constellation", l: "en_xx", k: "11", v: "♒️ Aquarius", r: ""),
        "12": Code(t: "Constellation", l: "en_xx", k: "12", v: "♓️ Pisces", r: ""),
    ],
    "Constellation_ja_jp" : [
        "01": Code(t: "Constellation", l: "ja_jp", k: "01", v: "♈️ おひつじ座", r: ""),
        "02": Code(t: "Constellation", l: "ja_jp", k: "02", v: "♉️ おうし座", r: ""),
        "03": Code(t: "Constellation", l: "ja_jp", k: "03", v: "♊️ ふたご座", r: ""),
        "04": Code(t: "Constellation", l: "ja_jp", k: "04", v: "♋️ かに座", r: ""),
        "05": Code(t: "Constellation", l: "ja_jp", k: "05", v: "♌️ しし座", r: ""),
        "06": Code(t: "Constellation", l: "ja_jp", k: "06", v: "♍️ おとめ座", r: ""),
        "07": Code(t: "Constellation", l: "ja_jp", k: "07", v: "♎️ てんびん座", r: ""),
        "08": Code(t: "Constellation", l: "ja_jp", k: "08", v: "♏️ さそり座", r: ""),
        "09": Code(t: "Constellation", l: "ja_jp", k: "09", v: "♐️ いて座", r: ""),
        "10": Code(t: "Constellation", l: "ja_jp", k: "10", v: "♑️ やぎ座", r: ""),
        "11": Code(t: "Constellation", l: "ja_jp", k: "11", v: "♒️ みずがめ座", r: ""),
        "12": Code(t: "Constellation", l: "ja_jp", k: "12", v: "♓️ うお座", r: ""),
    ],
    "Constellation_zh_cn" : [
        "01": Code(t: "Constellation", l: "zh_cn", k: "01", v: "♈️ 白羊座", r: ""),
        "02": Code(t: "Constellation", l: "zh_cn", k: "02", v: "♉️ 金牛座", r: ""),
        "03": Code(t: "Constellation", l: "zh_cn", k: "03", v: "♊️ 双子座", r: ""),
        "04": Code(t: "Constellation", l: "zh_cn", k: "04", v: "♋️ 巨蟹座", r: ""),
        "05": Code(t: "Constellation", l: "zh_cn", k: "05", v: "♌️ 狮子座", r: ""),
        "06": Code(t: "Constellation", l: "zh_cn", k: "06", v: "♍️ 处女座", r: ""),
        "07": Code(t: "Constellation", l: "zh_cn", k: "07", v: "♎️ 天平座", r: ""),
        "08": Code(t: "Constellation", l: "zh_cn", k: "08", v: "♏️ 蝎子座", r: ""),
        "09": Code(t: "Constellation", l: "zh_cn", k: "09", v: "♐️ 射手座", r: ""),
        "10": Code(t: "Constellation", l: "zh_cn", k: "10", v: "♑️ 摩羯座", r: ""),
        "11": Code(t: "Constellation", l: "zh_cn", k: "11", v: "♒️ 水瓶座", r: ""),
        "12": Code(t: "Constellation", l: "zh_cn", k: "12", v: "♓️ 双鱼座", r: ""),
    ]

]

/// <#Description#>
///
/// - gendre: <#gendre description#>
/// - occupation: <#occupation description#>
/// - hoby: <#hoby description#>
/// - appearance: <#appearance description#>
public enum CodeName: String {
    case gendre = "Gendre"
    case occupation = "Occupation"
    case hobby = "Hobby"
    case appearance = "Appearance"
    case age = "Age"
    case constellation = "Constellation"
}

/// <#Description#>
///
/// - Parameters:
///   - name: <#name description#>
///   - key: <#key description#>
///   - locale: <#locale description#>
/// - Returns: <#return value description#>
public func getCode (name: CodeName, of key: String, of locale: Locale?) -> Code? {
    // TODO
    return nil
}


///
/// <#Description#>
///
/// - Parameter locale: <#locale description#>
/// - Returns: <#return value description#>
public func gendres(locale: Locale? = Locale.current) -> [String: Code] {
    let loc = localeStr(locale!)
    let type = CodeName.gendre.rawValue + loc

    return mittyCodes[type]!
}

public func agegroups(locale: Locale? = Locale.current) -> [String: Code] {
    let loc = localeStr(locale!)
    let type = CodeName.age.rawValue + loc

    return mittyCodes[type]!
}

/// <#Description#>
///
/// - Parameter locale: <#locale description#>
/// - Returns: <#return value description#>
public func appearances(locale: Locale? = Locale.current) -> [String: Code] {
    let loc = localeStr(locale!)
    let type = CodeName.appearance.rawValue + loc

    return mittyCodes[type]!
}

/// <#Description#>
///
/// - Parameter locale: <#locale description#>
/// - Returns: <#return value description#>
public func occupations(locale: Locale? = Locale.current) -> [String: Code] {
    let loc = localeStr(locale!)
    let type = CodeName.occupation.rawValue + loc
    
    return mittyCodes[type]!
}

/// <#Description#>
///
/// - Parameter locale: <#locale description#>
/// - Returns: <#return value description#>
public func hobbys(locale: Locale? = Locale.current) -> [String: Code] {
    let loc = localeStr(locale!)
    let type = CodeName.hobby.rawValue + loc
    
    return mittyCodes[type]!
}

public func constellations(locale: Locale? = Locale.current) -> [String: Code] {
    let loc = localeStr(locale!)
    let type = CodeName.constellation.rawValue + loc
    
    return mittyCodes[type]!
}

private func localeStr(_ locale: Locale) -> String {
    var loc = ""

    if locale.languageCode?.lowercased() == "ja" {
        loc = "_ja_jp"
    } else if locale.languageCode?.lowercased() == "zh" {
        loc = "_zh_cn"
    }
    return loc
}

/// <#Description#>
///
/// - Parameters:
///   - key: <#key description#>
///   - locale: <#locale description#>
public func gendre(of key: String, locale: Locale? = Locale.current) -> Code? {

    let type = "Gendre" + localeStr(locale!)

    return mittyCodes[type]?[key]
}

public func agegroup(of key: String, locale: Locale? = Locale.current) -> Code? {

    let type = "Age" + localeStr(locale!)

    return mittyCodes[type]?[key]
}

public func occupation(of key: String, locale: Locale? = Locale.current) -> Code? {
    
    let type = "Occupation" + localeStr(locale!)
    
    return mittyCodes[type]?[key]
}

public func hobby(of key: String, locale: Locale? = Locale.current) -> Code? {
    
    let type = "Hobby" + localeStr(locale!)
    
    return mittyCodes[type]?[key]
}

public func CONSTELLATION(of key: String, locale: Locale? = Locale.current) -> Code? {
    
    let type = "Constellation" + localeStr(locale!)
    
    return mittyCodes[type]?[key]
}


/// <#Description#>
///
/// - Parameters:
///   - key: <#key description#>
///   - locale: <#locale description#>
/// - Returns: <#return value description#>
public func appearance(of key: String, locale: Locale? = Locale.current) -> Code? {
    let type = "Appearance" + localeStr(locale!)
    return mittyCodes[type]?[key]
}
