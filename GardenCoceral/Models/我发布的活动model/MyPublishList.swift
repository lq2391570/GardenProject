//
//  MyPublishList.swift
//
//  Created by shiliuhua on 20/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class MyPublishList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let note = "note"
    static let pubAddress = "pubAddress"
    static let address = "address"
    static let likes = "likes"
    static let date = "date"
    static let member = "member"
    static let liked = "liked"
    static let id = "id"
    static let feedId = "feedId"
    static let comments = "comments"
    static let joinNum = "joinNum"
    static let num = "num"
    static let pubDate = "pubDate"
    static let images = "images"
    static let lat = "lat"
    static let lng = "lng"
    
  }

  // MARK: Properties
  public var note: String?
  public var pubAddress: String?
  public var address: String?
  public var likes: Int?
  public var date: String?
  public var member: MyPublishMember?
  public var liked: Bool? = false
  public var id: Int?
  public var feedId: Int?
  public var comments: Int?
  public var joinNum: Int?
  public var num: Int?
  public var pubDate: String?
  public var images: [MyPublishImages]?
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
    note = json[SerializationKeys.note].string
    pubAddress = json[SerializationKeys.pubAddress].string
    address = json[SerializationKeys.address].string
    
    likes = json[SerializationKeys.likes].int
    date = json[SerializationKeys.date].string
    member = MyPublishMember(json: json[SerializationKeys.member])
    liked = json[SerializationKeys.liked].boolValue
    id = json[SerializationKeys.id].int
    feedId = json[SerializationKeys.feedId].int
    comments = json[SerializationKeys.comments].int
    joinNum = json[SerializationKeys.joinNum].int
    num = json[SerializationKeys.num].int
    pubDate = json[SerializationKeys.pubDate].string
     if let items = json[SerializationKeys.images].array { images = items.map { MyPublishImages(json: $0) } }
    lat = json[SerializationKeys.lat].float
    lng = json[SerializationKeys.lng].float
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = note { dictionary[SerializationKeys.note] = value }
    if let value = pubAddress { dictionary[SerializationKeys.pubAddress] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    if let value = likes { dictionary[SerializationKeys.likes] = value }
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = member { dictionary[SerializationKeys.member] = value.dictionaryRepresentation() }
    dictionary[SerializationKeys.liked] = liked
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = feedId { dictionary[SerializationKeys.feedId] = value }
    if let value = comments { dictionary[SerializationKeys.comments] = value }
    if let value = joinNum { dictionary[SerializationKeys.joinNum] = value }
    if let value = num { dictionary[SerializationKeys.num] = value }
    if let value = pubDate { dictionary[SerializationKeys.pubDate] = value }
    if let value = images { dictionary[SerializationKeys.images] = value.map { $0.dictionaryRepresentation() } }
    if let value = lat { dictionary[SerializationKeys.lat] = value }
    if let value = lng { dictionary[SerializationKeys.lng] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.note = aDecoder.decodeObject(forKey: SerializationKeys.note) as? String
    self.pubAddress = aDecoder.decodeObject(forKey: SerializationKeys.pubAddress) as? String
     self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
    self.likes = aDecoder.decodeObject(forKey: SerializationKeys.likes) as? Int
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.member = aDecoder.decodeObject(forKey: SerializationKeys.member) as? MyPublishMember
    self.liked = aDecoder.decodeBool(forKey: SerializationKeys.liked)
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.feedId = aDecoder.decodeObject(forKey: SerializationKeys.feedId) as? Int
    self.comments = aDecoder.decodeObject(forKey: SerializationKeys.comments) as? Int
    self.joinNum = aDecoder.decodeObject(forKey: SerializationKeys.joinNum) as? Int
    self.num = aDecoder.decodeObject(forKey: SerializationKeys.num) as? Int
    self.pubDate = aDecoder.decodeObject(forKey: SerializationKeys.pubDate) as? String
     self.images = aDecoder.decodeObject(forKey: SerializationKeys.images) as? [MyPublishImages]
    self.lat = aDecoder.decodeObject(forKey: SerializationKeys.lat) as? Float
    self.lng = aDecoder.decodeObject(forKey: SerializationKeys.lng) as? Float
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(note, forKey: SerializationKeys.note)
    aCoder.encode(pubAddress, forKey: SerializationKeys.pubAddress)
     aCoder.encode(address, forKey: SerializationKeys.address)
    aCoder.encode(likes, forKey: SerializationKeys.likes)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(member, forKey: SerializationKeys.member)
    aCoder.encode(liked, forKey: SerializationKeys.liked)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(feedId, forKey: SerializationKeys.feedId)
    aCoder.encode(comments, forKey: SerializationKeys.comments)
    aCoder.encode(joinNum, forKey: SerializationKeys.joinNum)
    aCoder.encode(num, forKey: SerializationKeys.num)
    aCoder.encode(pubDate, forKey: SerializationKeys.pubDate)
     aCoder.encode(images, forKey: SerializationKeys.images)
    aCoder.encode(lat, forKey: SerializationKeys.lat)
    aCoder.encode(lng, forKey: SerializationKeys.lng)
  }

}
