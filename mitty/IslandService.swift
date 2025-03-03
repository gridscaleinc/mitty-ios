//
//  IslandService.swift
//  mitty
//
//  Created by gridscale on 2016/11/08.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// 島関連サービス。
class IslandService: Service {
    static var instance: IslandService = {
        let instance = IslandService()
        return instance
    }()

    private override init() {

    }

    /// 新しい島登録。
    ///　島とは（場所のこと）
    /// - Returns: なし。
    func registerNewIsland(_ landInfo: IslandPick, onError: @escaping (_ error: Any) -> Void = { _ in }) {
        let request = NewIslandReq()

        //nickname           : string      --(O)  愛称
        request.setStr(.nickname, "")

        //name               : string      --(M)  名称
        request.setStr(.name, landInfo.placeMark?.name)

        //logoId             : int         --(O)  LogoのContent Id
        //        request.setStr(.logoId, "")

        //description        : string      --(O)  説明
        request.setStr(.description, "")

        //category           : string      --(M)  カテゴリ
        request.setStr(.category, "UKNOWN")

        //mobilityType       : string      --(M)  移動性分類
        request.setStr(.mobilityTyep, "NONE")

        //realityType        : string      --(M)  実在性分類
        request.setStr(.realityType, "REAL")

        //ownershipType      : string      --(M)  所有者分類
        request.setStr(.ownershipTYpe, "PUBLIC")

        //ownerName          : string      --(O)  所有者名
        request.setStr(.ownerName, "UNOWNED")

        //ownerId            : int         --(O)  所有者のMitty User Id
        //        request.setStr(.ownerId,"")

        //creatorId          : int         --(O)  作成者のMitty User Id
        //        request.setStr(.creatorId,"")

        //meetingId          : int         --(O)  会議Id
        //        request.setStr(.meetingId,"")

        //galleryId          : int         --(O)  ギャラリーID
        //        request.setStr(.galleryId,"")

        //tel                : string      --(O)  電話番号
        request.setStr(.tel, "")

        //fax                : string      --(O)  FAX
        request.setStr(.fax, "")

        //mailaddress        : string      --(O)  メールアドレス
        request.setStr(.mailaddress, "")

        //webpage            : string      --(O) 　WebページのURL
        request.setStr(.webpage, "")

        //likes              : string      --(O)  いいねの数
        request.setStr(.likes, "0")

        //countryCode        : string      --(O)  国コード
        request.setStr(.countryCode, landInfo.placeMark?.isoCountryCode)

        //countryName        : string      --(O)  国名称
        request.setStr(.countryName, landInfo.placeMark?.country)

        //state              : string      --(O)  都道府県
        request.setStr(.state, landInfo.placeMark?.administrativeArea)

        //city               : string      --(O)  市、区
        request.setStr(.city, landInfo.placeMark?.locality)

        //postcode           : string      --(O)  郵便番号
        request.setStr(.postcode, landInfo.placeMark?.postalCode)

        //thoroghfare        : string      --(O)  大通り
        request.setStr(.thoroghfare, landInfo.placeMark?.thoroughfare)

        //subthroghfare      : string      --(O)  通り
        request.setStr(.subthorghfare, landInfo.placeMark?.subThoroughfare)

        //buildingName       : string      --(O)  建物名称
        request.setStr(.buildingName, "")

        //floorNumber        : string      --(O)  フロー番号
        request.setStr(.floorNumber, String(describing: landInfo.placeMark?.location?.floor?.level))

        //roomNumber         : string      --(O)  部屋番号
        request.setStr(.roomNumber, "")

        //address1           : string      --(O)  住所行１
        // print(landInfo.placeMark?.addressDictionary)
        if let addressLines = landInfo.placeMark?.addressDictionary?["FormattedAddressLines"] as? NSArray {
            //address1-3           : string      --(O)  住所行１-3
            if addressLines.count > 0 {
                request.setStr(.address1, addressLines[0] as? String)
            }
            if addressLines.count > 1 {
                request.setStr(.address2, addressLines[1] as? String)
            }
            if addressLines.count > 2 {
                request.setStr(.address3, addressLines[2] as? String)
            }
        }

        //latitude           : double      --(O)  地理位置の緯度
        if let lat = landInfo.placeMark?.location?.coordinate.latitude {
            request.setDouble(.latitude, String(describing: lat))
        } else {
            request.setDouble(.latitude, "999") // 不可能な値を設定する。NULL扱い
        }

        //longitude          : double      --(O)  地理位置の経度
        if let longi = landInfo.placeMark?.location?.coordinate.longitude {
            request.setDouble(.longitude, String(describing: longi))
        } else {
            request.setDouble(.longitude, "999") // 不可能な値を設定する。NULL扱い。
        }

        LoadingProxy.on()

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let api = APIClient(path: "/new/island", method: .post, parameters: request.parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let islandId = json["islandId"].int64Value
            landInfo.id = islandId
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    /// 島情報取得。
    ///
    /// - Returns: なし。
    func fetchIslandInfo(_ name: String, callback: @escaping (_ infoList: [IslandInfo]) -> Void, onError: @escaping (_ error: Any) -> Void = { _ in }) {

        let parameters: [String: Any] = [
            "name": name
        ]

        LoadingProxy.on()
        
        let api = APIClient(path: "/island/info", method: .get, parameters: parameters)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let islands = json["islands"]
            let islandInfoList = self.bindIslands(islands)
            callback (islandInfoList)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    /// 島一覧オブジェクトバインド。
    ///
    /// - Parameter json: JSON
    /// - Returns: 島情報の配列。
    func bindIslands(_ json: JSON) -> [IslandInfo] {
        var islandInfoList = [IslandInfo]()
        for (_, island) in json {
            islandInfoList.append(bindIsland(island))
        }

        return islandInfoList
    }


    /// 島個別情報バインド。
    ///
    /// - Parameter json: JSON
    /// - Returns: 島情報。
    func bindIsland(_ json: JSON) -> IslandInfo {
        let islandInfo = IslandInfo()

        islandInfo.id = json["id"].int64!
        islandInfo.name = json["name"].stringValue
        islandInfo.nickname = json["nickname"].stringValue
        islandInfo.logoUrl = json["logoUrl"].stringValue
        islandInfo.address1 = json["address1"].stringValue
        islandInfo.address2 = json["address2"].stringValue
        islandInfo.address3 = json["address3"].stringValue
        islandInfo.latitude = json["latitude"].doubleValue
        islandInfo.longitude = json["longitude"].doubleValue
        islandInfo.meetingId = json["meetingId"].int64Value

        return islandInfo

    }
}
