//
//  MemberElegantList.swift
//
//  Created by shiliuhua on 28/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class MemberElegantList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let phone = "phone"
    static let name = "name"
    static let logo = "logo"
    static let id = "id"
    static let address = "address"
  }

  // MARK: Properties
  public var phone: String?
  public var name: String?
  public var logo: String?
  public var id: Int?
  public var address: String?

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
    phone = json[SerializationKeys.phone].string
    name = json[SerializationKeys.name].string
    logo = json[SerializationKeys.logo].string
    id = json[SerializationKeys.id].int
    address = json[SerializationKeys.address].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = phone { dictionary[SerializationKeys.phone] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = logo { dictionary[SerializationKeys.logo] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.phone = aDecoder.decodeObject(forKey: SerializationKeys.phone) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.logo = aDecoder.decodeObject(forKey: SerializationKeys.logo) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(phone, forKey: SerializationKeys.phone)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(logo, forKey: SerializationKeys.logo)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(address, forKey: SerializationKeys.address)
  }

}
