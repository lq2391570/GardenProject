//
//  BiggestHotBacketBiggestHotBacket.swift
//
//  Created by shiliuhua on 26/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class BiggestHotBacketBiggestHotBacket: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let member = "member"
    static let id = "id"
    static let code = "code"
    static let msg = "msg"
  }

  // MARK: Properties
  public var member: BiggestHotBacketMember?
  public var id: Int?
  public var code: Int?
  public var msg: String?

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
    member = BiggestHotBacketMember(json: json[SerializationKeys.member])
    id = json[SerializationKeys.id].int
    code = json[SerializationKeys.code].int
    msg = json[SerializationKeys.msg].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = member { dictionary[SerializationKeys.member] = value.dictionaryRepresentation() }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = code { dictionary[SerializationKeys.code] = value }
    if let value = msg { dictionary[SerializationKeys.msg] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.member = aDecoder.decodeObject(forKey: SerializationKeys.member) as? BiggestHotBacketMember
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.code = aDecoder.decodeObject(forKey: SerializationKeys.code) as? Int
    self.msg = aDecoder.decodeObject(forKey: SerializationKeys.msg) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(member, forKey: SerializationKeys.member)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(code, forKey: SerializationKeys.code)
    aCoder.encode(msg, forKey: SerializationKeys.msg)
  }

}
