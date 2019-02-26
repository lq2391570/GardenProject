//
//  ProjectList.swift
//
//  Created by shiliuhua on 23/05/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ProjectList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let logo = "logo"
    static let desc = "desc"
    static let id = "id"
    static let date = "date"
  }

  // MARK: Properties
  public var name: String?
  public var logo: String?
  public var desc: String?
  public var id: Int?
  public var date: String?

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
    name = json[SerializationKeys.name].string
    logo = json[SerializationKeys.logo].string
    desc = json[SerializationKeys.desc].string
    id = json[SerializationKeys.id].int
    date = json[SerializationKeys.date].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = logo { dictionary[SerializationKeys.logo] = value }
    if let value = desc { dictionary[SerializationKeys.desc] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = date { dictionary[SerializationKeys.date] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.logo = aDecoder.decodeObject(forKey: SerializationKeys.logo) as? String
    self.desc = aDecoder.decodeObject(forKey: SerializationKeys.desc) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(logo, forKey: SerializationKeys.logo)
    aCoder.encode(desc, forKey: SerializationKeys.desc)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(date, forKey: SerializationKeys.date)
  }

}
