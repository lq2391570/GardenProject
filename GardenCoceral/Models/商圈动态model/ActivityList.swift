//
//  ActivityList.swift
//
//  Created by shiliuhua on 17/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ActivityList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let likes = "likes"
    static let address = "address"
    static let expand = "expand"
    static let date = "date"
    static let haveRedPacket = "haveRedPacket"
    static let lat = "lat"
    static let catalog = "catalog"
    static let member = "member"
    static let activity = "activity"
    static let lng = "lng"
    static let liked = "liked"
    static let id = "id"
    static let comments = "comments"
    static let images = "images"
    static let note = "note"
  }

  // MARK: Properties
  public var likes: Int?
  public var address: String?
  public var expand: Bool? = false
  public var date: String?
  public var haveRedPacket: Int?
  public var lat: Float?
  public var catalog: Int?
  public var member: ActivityMember?
  public var activity: ActivityActivity?
  public var lng: Float?
  public var liked: Bool? = false
  public var id: Int?
  public var comments: Int?
  public var images: [ActivityImages]?
public var note:String?
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
    likes = json[SerializationKeys.likes].int
    address = json[SerializationKeys.address].string
     note = json[SerializationKeys.note].string
    expand = json[SerializationKeys.expand].boolValue
    date = json[SerializationKeys.date].string
    haveRedPacket = json[SerializationKeys.haveRedPacket].int
    lat = json[SerializationKeys.lat].float
    catalog = json[SerializationKeys.catalog].int
    member = ActivityMember(json: json[SerializationKeys.member])
    activity = ActivityActivity(json: json[SerializationKeys.activity])
    lng = json[SerializationKeys.lng].float
    liked = json[SerializationKeys.liked].boolValue
    id = json[SerializationKeys.id].int
    comments = json[SerializationKeys.comments].int
    if let items = json[SerializationKeys.images].array { images = items.map { ActivityImages(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = likes { dictionary[SerializationKeys.likes] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
      if let value = note { dictionary[SerializationKeys.note] = value }
    dictionary[SerializationKeys.expand] = expand
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = haveRedPacket { dictionary[SerializationKeys.haveRedPacket] = value }
    if let value = lat { dictionary[SerializationKeys.lat] = value }
    if let value = catalog { dictionary[SerializationKeys.catalog] = value }
    if let value = member { dictionary[SerializationKeys.member] = value.dictionaryRepresentation() }
    if let value = activity { dictionary[SerializationKeys.activity] = value.dictionaryRepresentation() }
    if let value = lng { dictionary[SerializationKeys.lng] = value }
    dictionary[SerializationKeys.liked] = liked
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = comments { dictionary[SerializationKeys.comments] = value }
    if let value = images { dictionary[SerializationKeys.images] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.likes = aDecoder.decodeObject(forKey: SerializationKeys.likes) as? Int
    self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
     self.note = aDecoder.decodeObject(forKey: SerializationKeys.note) as? String
    self.expand = aDecoder.decodeBool(forKey: SerializationKeys.expand)
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.haveRedPacket = aDecoder.decodeObject(forKey: SerializationKeys.haveRedPacket) as? Int
    self.lat = aDecoder.decodeObject(forKey: SerializationKeys.lat) as? Float
    self.catalog = aDecoder.decodeObject(forKey: SerializationKeys.catalog) as? Int
    self.member = aDecoder.decodeObject(forKey: SerializationKeys.member) as? ActivityMember
    self.activity = aDecoder.decodeObject(forKey: SerializationKeys.activity) as? ActivityActivity
    self.lng = aDecoder.decodeObject(forKey: SerializationKeys.lng) as? Float
    self.liked = aDecoder.decodeBool(forKey: SerializationKeys.liked)
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.comments = aDecoder.decodeObject(forKey: SerializationKeys.comments) as? Int
    self.images = aDecoder.decodeObject(forKey: SerializationKeys.images) as? [ActivityImages]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(likes, forKey: SerializationKeys.likes)
    aCoder.encode(address, forKey: SerializationKeys.address)
     aCoder.encode(note, forKey: SerializationKeys.note)
    aCoder.encode(expand, forKey: SerializationKeys.expand)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(haveRedPacket, forKey: SerializationKeys.haveRedPacket)
    aCoder.encode(lat, forKey: SerializationKeys.lat)
    aCoder.encode(catalog, forKey: SerializationKeys.catalog)
    aCoder.encode(member, forKey: SerializationKeys.member)
    aCoder.encode(activity, forKey: SerializationKeys.activity)
    aCoder.encode(lng, forKey: SerializationKeys.lng)
    aCoder.encode(liked, forKey: SerializationKeys.liked)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(comments, forKey: SerializationKeys.comments)
    aCoder.encode(images, forKey: SerializationKeys.images)
  }

}
