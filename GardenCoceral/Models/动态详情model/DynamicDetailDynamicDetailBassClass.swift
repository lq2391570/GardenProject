//
//  DynamicDetailDynamicDetailBassClass.swift
//
//  Created by shiliuhua on 11/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DynamicDetailDynamicDetailBassClass: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let note = "note"
    static let likes = "likes"
    static let address = "address"
    static let expand = "expand"
    static let date = "date"
    static let haveRedPacket = "haveRedPacket"
    static let opend = "opend"
    static let lat = "lat"
    static let catalog = "catalog"
    static let member = "member"
    static let lng = "lng"
    static let liked = "liked"
    static let id = "id"
    static let code = "code"
    static let comments = "comments"
    static let images = "images"
    static let msg = "msg"
    static let activity = "activity"
    static let packetId = "packetId"
    static let money = "money"
    
    
    
  }

  // MARK: Properties
  public var note: String?
  public var likes: Int?
  public var address: String?
  public var expand: Bool? = false
  public var date: String?
  public var haveRedPacket: Bool? = false
  public var lat: Int?
  public var catalog: Int?
  public var member: DynamicDetailMember?
  public var lng: Int?
  public var liked: Bool? = false
  public var opend: Bool? = false
  public var id: Int?
  public var code: Int?
  public var comments: Int?
  public var images: [DynamicDetailImages]?
  public var msg: String?
  public var activity: DynamicDetailActivity?
    public var packetId: Int?
    public var money:Double?
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
    note = json[SerializationKeys.note].string
    likes = json[SerializationKeys.likes].int
    address = json[SerializationKeys.address].string
    expand = json[SerializationKeys.expand].boolValue
    date = json[SerializationKeys.date].string
    haveRedPacket = json[SerializationKeys.haveRedPacket].boolValue
    lat = json[SerializationKeys.lat].int
    catalog = json[SerializationKeys.catalog].int
    member = DynamicDetailMember(json: json[SerializationKeys.member])
    lng = json[SerializationKeys.lng].int
    liked = json[SerializationKeys.liked].boolValue
    opend = json[SerializationKeys.opend].boolValue
    id = json[SerializationKeys.id].int
     packetId = json[SerializationKeys.packetId].int
    money = json[SerializationKeys.money].double
    
    code = json[SerializationKeys.code].int
    comments = json[SerializationKeys.comments].int
    if let items = json[SerializationKeys.images].array { images = items.map { DynamicDetailImages(json: $0) } }
    msg = json[SerializationKeys.msg].string
    activity = DynamicDetailActivity(json: json[SerializationKeys.activity])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = note { dictionary[SerializationKeys.note] = value }
    if let value = likes { dictionary[SerializationKeys.likes] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    dictionary[SerializationKeys.expand] = expand
    if let value = date { dictionary[SerializationKeys.date] = value }
    dictionary[SerializationKeys.haveRedPacket] = haveRedPacket
    if let value = lat { dictionary[SerializationKeys.lat] = value }
    if let value = catalog { dictionary[SerializationKeys.catalog] = value }
    if let value = member { dictionary[SerializationKeys.member] = value.dictionaryRepresentation() }
    if let value = lng { dictionary[SerializationKeys.lng] = value }
    dictionary[SerializationKeys.liked] = liked
     dictionary[SerializationKeys.opend] = opend
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = packetId { dictionary[SerializationKeys.packetId] = value }
    if let value = money { dictionary[SerializationKeys.money] = value }
    if let value = code { dictionary[SerializationKeys.code] = value }
    if let value = comments { dictionary[SerializationKeys.comments] = value }
    if let value = images { dictionary[SerializationKeys.images] = value.map { $0.dictionaryRepresentation() } }
    if let value = msg { dictionary[SerializationKeys.msg] = value }
     if let value = activity { dictionary[SerializationKeys.activity] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.note = aDecoder.decodeObject(forKey: SerializationKeys.note) as? String
    self.likes = aDecoder.decodeObject(forKey: SerializationKeys.likes) as? Int
    self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
    self.expand = aDecoder.decodeBool(forKey: SerializationKeys.expand)
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.haveRedPacket = aDecoder.decodeBool(forKey: SerializationKeys.haveRedPacket)
    self.lat = aDecoder.decodeObject(forKey: SerializationKeys.lat) as? Int
    self.catalog = aDecoder.decodeObject(forKey: SerializationKeys.catalog) as? Int
    self.member = aDecoder.decodeObject(forKey: SerializationKeys.member) as? DynamicDetailMember
    self.lng = aDecoder.decodeObject(forKey: SerializationKeys.lng) as? Int
    self.liked = aDecoder.decodeBool(forKey: SerializationKeys.liked)
    self.opend = aDecoder.decodeBool(forKey: SerializationKeys.opend)
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.packetId = aDecoder.decodeObject(forKey: SerializationKeys.packetId) as? Int
    self.money = aDecoder.decodeDouble(forKey: SerializationKeys.money)
    self.code = aDecoder.decodeObject(forKey: SerializationKeys.code) as? Int
    self.comments = aDecoder.decodeObject(forKey: SerializationKeys.comments) as? Int
    self.images = aDecoder.decodeObject(forKey: SerializationKeys.images) as? [DynamicDetailImages]
    self.msg = aDecoder.decodeObject(forKey: SerializationKeys.msg) as? String
     self.activity = aDecoder.decodeObject(forKey: SerializationKeys.activity) as? DynamicDetailActivity
  }
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(note, forKey: SerializationKeys.note)
    aCoder.encode(likes, forKey: SerializationKeys.likes)
    aCoder.encode(address, forKey: SerializationKeys.address)
    aCoder.encode(expand, forKey: SerializationKeys.expand)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(haveRedPacket, forKey: SerializationKeys.haveRedPacket)
    aCoder.encode(lat, forKey: SerializationKeys.lat)
    aCoder.encode(catalog, forKey: SerializationKeys.catalog)
    aCoder.encode(member, forKey: SerializationKeys.member)
    aCoder.encode(lng, forKey: SerializationKeys.lng)
    aCoder.encode(liked, forKey: SerializationKeys.liked)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(packetId, forKey: SerializationKeys.packetId)
    
    aCoder.encode(money, forKey: SerializationKeys.money)
    aCoder.encode(code, forKey: SerializationKeys.code)
    aCoder.encode(comments, forKey: SerializationKeys.comments)
    aCoder.encode(images, forKey: SerializationKeys.images)
    aCoder.encode(msg, forKey: SerializationKeys.msg)
    aCoder.encode(activity, forKey: SerializationKeys.activity)
  }

}
