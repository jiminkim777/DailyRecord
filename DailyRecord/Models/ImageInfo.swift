//
//  ImageInfo.swift
//  DailyRecord
//
//  Created by jimin on 2022/04/12.
//

import Foundation
import RealmSwift
 
class ImageInfo: Object {
    //@objc dynamic var id = ""
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    
    override static func primaryKey() -> String? {
        return "year"
    }
}



