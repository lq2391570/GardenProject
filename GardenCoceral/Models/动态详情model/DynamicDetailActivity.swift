//
//  DynamicDetailActivity.swift
//
//  Created by shiliuhua on 13/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DynamicDetailActivity: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let joinNum = "joinNum"
    static let date = "date"
    static let num = "num"
    static let note = "note"
    static let address = "address"
    static let haveJoin = "haveJoin"
    static let money = "money"
    static let type = "type"
    static let id = "id"
    static let lat = "lat"
    static let lng = "lng"
  }

  // MARK: Properties
  public var joinNum: Int?
  public var date: String?
  public var num: Int?
  public var note: String?
    public var address:String?
    public var haveJoin:Bool?
    public var money:Double?
    public var type:Int?
    public var id:Int?
    public var lat: Float?
    public var lng: Float?
  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    joinNum = json[SerializationKeys.joinNum].int
    date = json[SerializationKeys.date].string
    num = json[SerializationKeys.num].int
    note = json[SerializationKeys.note].string
    address = json[SerializationKeys.address].string
    
    haveJoin = json[SerializationKeys.haveJoin].bool
    money = json[SerializationKeys.money].double
    type = json[SerializationKeys.type].int
    id = json[SerializationKeys.id].int
    lat = json[SerializationKeys.lat].float
    lng = json[SerializationKeys.lng].float
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = joinNum { dictionary[SerializationKeys.joinNum] = value }
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = num { dictionary[SerializationKeys.num] = value }
    if let value = note { dictionary[SerializationKeys.note] = value }
     if let value = address { dictionary[SerializationKeys.address] = value }
    
    if let value = haveJoin { dictionary[SerializationKeys.haveJoin] = value }
    if let value = money { dictionary[SerializationKeys.money] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = id{ dictionary[SerializationKeys.id] = value }
    if let value = lat { dictionary[SerializationKeys.lat] = value }
    if let value = lng { dictionary[SerializationKeys.lng] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.joinNum = aDecoder.decodeObject(forKey: SerializationKeys.joinNum) as? Int
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.num = aDecoder.decodeObject(forKey: SerializationKeys.num) as? Int
    self.note = aDecoder.decodeObject(forKey: SerializationKeys.note) as? String
    self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
    self.haveJoin = aDecoder.decodeObject(forKey: SerializationKeys.haveJoin) as? Bool
    self.money = aDecoder.decodeObject(forKey: SerializationKeys.money) as? Double
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? Int
     self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.lat = aDecoder.decodeObject(forKey: SerializationKeys.lat) as? Float
    self.lng = aDecoder.decodeObject(forKey: SerializationKeys.lng) as? Float
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(joinNum, forKey: SerializationKeys.joinNum)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(num, forKey: SerializationKeys.num)
    aCoder.encode(note, forKey: SerializationKeys.note)
    aCoder.encode(address, forKey: SerializationKeys.address)
    
    aCoder.encode(haveJoin, forKey: SerializationKeys.haveJoin)
    aCoder.encode(money, forKey: SerializationKeys.money)
    aCoder.encode(type, forKey: SerializationKeys.type)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(lat, forKey: SerializationKeys.lat)
    aCoder.encode(lng, forKey: SerializationKeys.lng)
  }

}
