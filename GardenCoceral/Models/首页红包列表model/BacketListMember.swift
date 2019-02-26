//
//  BacketListMember.swift
//
//  Created by shiliuhua on 02/05/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class BacketListMember: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let companyName = "companyName"
    static let avatar = "avatar"
    static let job = "job"
    static let id = "id"
  }

  // MARK: Properties
  public var name: String?
  public var companyName: String?
  public var avatar: String?
  public var job: String?
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
    name = json[SerializationKeys.name].string
    companyName = json[SerializationKeys.companyName].string
    avatar = json[SerializationKeys.avatar].string
    job = json[SerializationKeys.job].string
    id = json[SerializationKeys.id].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = companyName { dictionary[SerializationKeys.companyName] = value }
    if let value = avatar { dictionary[SerializationKeys.avatar] = value }
    if let value = job { dictionary[SerializationKeys.job] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.companyName = aDecoder.decodeObject(forKey: SerializationKeys.companyName) as? String
    self.avatar = aDecoder.decodeObject(forKey: SerializationKeys.avatar) as? String
    self.job = aDecoder.decodeObject(forKey: SerializationKeys.job) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(companyName, forKey: SerializationKeys.companyName)
    aCoder.encode(avatar, forKey: SerializationKeys.avatar)
    aCoder.encode(job, forKey: SerializationKeys.job)
    aCoder.encode(id, forKey: SerializationKeys.id)
  }

}
