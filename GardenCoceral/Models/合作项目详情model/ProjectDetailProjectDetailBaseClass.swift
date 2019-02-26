//
//  ProjectDetailProjectDetailBaseClass.swift
//
//  Created by shiliuhua on 23/05/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ProjectDetailProjectDetailBaseClass: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let note = "note"
    static let name = "name"
    static let date = "date"
    static let desc = "desc"
    static let id = "id"
    static let money = "money"
    static let joins = "joins"
    static let code = "code"
    static let haveJoin = "haveJoin"
    static let logo = "logo"
    static let num = "num"
    static let msg = "msg"
  }

  // MARK: Properties
  public var note: String?
  public var name: String?
  public var date: String?
  public var desc: String?
  public var id: Int?
  public var money: Int?
  public var joins: [ProjectDetailJoins]?
  public var code: Int?
  public var haveJoin: Bool? = false
  public var logo: String?
  public var num: Int?
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
    note = json[SerializationKeys.note].string
    name = json[SerializationKeys.name].string
    date = json[SerializationKeys.date].string
    desc = json[SerializationKeys.desc].string
    id = json[SerializationKeys.id].int
    money = json[SerializationKeys.money].int
    if let items = json[SerializationKeys.joins].array { joins = items.map { ProjectDetailJoins(json: $0) } }
    code = json[SerializationKeys.code].int
    haveJoin = json[SerializationKeys.haveJoin].boolValue
    logo = json[SerializationKeys.logo].string
    num = json[SerializationKeys.num].int
    msg = json[SerializationKeys.msg].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = note { dictionary[SerializationKeys.note] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = desc { dictionary[SerializationKeys.desc] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = money { dictionary[SerializationKeys.money] = value }
    if let value = joins { dictionary[SerializationKeys.joins] = value.map { $0.dictionaryRepresentation() } }
    if let value = code { dictionary[SerializationKeys.code] = value }
    dictionary[SerializationKeys.haveJoin] = haveJoin
    if let value = logo { dictionary[SerializationKeys.logo] = value }
    if let value = num { dictionary[SerializationKeys.num] = value }
    if let value = msg { dictionary[SerializationKeys.msg] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.note = aDecoder.decodeObject(forKey: SerializationKeys.note) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.desc = aDecoder.decodeObject(forKey: SerializationKeys.desc) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.money = aDecoder.decodeObject(forKey: SerializationKeys.money) as? Int
    self.joins = aDecoder.decodeObject(forKey: SerializationKeys.joins) as? [ProjectDetailJoins]
    self.code = aDecoder.decodeObject(forKey: SerializationKeys.code) as? Int
    self.haveJoin = aDecoder.decodeBool(forKey: SerializationKeys.haveJoin)
    self.logo = aDecoder.decodeObject(forKey: SerializationKeys.logo) as? String
    self.num = aDecoder.decodeObject(forKey: SerializationKeys.num) as? Int
    self.msg = aDecoder.decodeObject(forKey: SerializationKeys.msg) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(note, forKey: SerializationKeys.note)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(desc, forKey: SerializationKeys.desc)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(money, forKey: SerializationKeys.money)
    aCoder.encode(joins, forKey: SerializationKeys.joins)
    aCoder.encode(code, forKey: SerializationKeys.code)
    aCoder.encode(haveJoin, forKey: SerializationKeys.haveJoin)
    aCoder.encode(logo, forKey: SerializationKeys.logo)
    aCoder.encode(num, forKey: SerializationKeys.num)
    aCoder.encode(msg, forKey: SerializationKeys.msg)
  }

}
