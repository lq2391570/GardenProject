//
//  HotBacketListList.swift
//
//  Created by shiliuhua on 26/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class HotBacketListList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let expand = "expand"
    static let member = "member"
    static let date = "date"
    static let money = "money"
  }

  // MARK: Properties
  public var expand: Bool? = false
  public var member: HotBacketListMember?
  public var date: String?
  public var money: Float?

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
    expand = json[SerializationKeys.expand].boolValue
    member = HotBacketListMember(json: json[SerializationKeys.member])
    date = json[SerializationKeys.date].string
    money = json[SerializationKeys.money].float
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.expand] = expand
    if let value = member { dictionary[SerializationKeys.member] = value.dictionaryRepresentation() }
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = money { dictionary[SerializationKeys.money] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.expand = aDecoder.decodeBool(forKey: SerializationKeys.expand)
    self.member = aDecoder.decodeObject(forKey: SerializationKeys.member) as? HotBacketListMember
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.money = aDecoder.decodeObject(forKey: SerializationKeys.money) as? Float
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(expand, forKey: SerializationKeys.expand)
    aCoder.encode(member, forKey: SerializationKeys.member)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(money, forKey: SerializationKeys.money)
  }

}
