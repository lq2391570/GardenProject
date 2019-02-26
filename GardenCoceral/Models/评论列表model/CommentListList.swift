//
//  CommentListList.swift
//
//  Created by shiliuhua on 12/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommentListList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let member = "member"
    static let note = "note"
    static let date = "date"
    static let id = "id"
  }

  // MARK: Properties
  public var member: CommentListMember?
  public var note: String?
  public var date: String?
  public var id: Int?

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
    member = CommentListMember(json: json[SerializationKeys.member])
    note = json[SerializationKeys.note].string
    date = json[SerializationKeys.date].string
    id = json[SerializationKeys.id].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = member { dictionary[SerializationKeys.member] = value.dictionaryRepresentation() }
    if let value = note { dictionary[SerializationKeys.note] = value }
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.member = aDecoder.decodeObject(forKey: SerializationKeys.member) as? CommentListMember
    self.note = aDecoder.decodeObject(forKey: SerializationKeys.note) as? String
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(member, forKey: SerializationKeys.member)
    aCoder.encode(note, forKey: SerializationKeys.note)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(id, forKey: SerializationKeys.id)
  }

}
