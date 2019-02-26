//
//  ProjectDetailJoins.swift
//
//  Created by shiliuhua on 23/05/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ProjectDetailJoins: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let member = "member"
    static let date = "date"
  }

  // MARK: Properties
  public var member: ProjectDetailMember?
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
    member = ProjectDetailMember(json: json[SerializationKeys.member])
    date = json[SerializationKeys.date].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = member { dictionary[SerializationKeys.member] = value.dictionaryRepresentation() }
    if let value = date { dictionary[SerializationKeys.date] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.member = aDecoder.decodeObject(forKey: SerializationKeys.member) as? ProjectDetailMember
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(member, forKey: SerializationKeys.member)
    aCoder.encode(date, forKey: SerializationKeys.date)
  }

}
