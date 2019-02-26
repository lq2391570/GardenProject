//
//  HotArticleHotArticleBassClass.swift
//
//  Created by shiliuhua on 11/04/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class HotArticleHotArticleBassClass: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let no = "no"
    static let code = "code"
    static let list = "list"
    static let size = "size"
    static let total = "total"
    static let totalPage = "totalPage"
    static let msg = "msg"
  }

  // MARK: Properties
  public var no: Int?
  public var code: Int?
  public var list: [HotArticleList]?
  public var size: Int?
  public var total: Int?
  public var totalPage: Int?
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
    no = json[SerializationKeys.no].int
    code = json[SerializationKeys.code].int
    if let items = json[SerializationKeys.list].array { list = items.map { HotArticleList(json: $0) } }
    size = json[SerializationKeys.size].int
    total = json[SerializationKeys.total].int
    totalPage = json[SerializationKeys.totalPage].int
    msg = json[SerializationKeys.msg].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = no { dictionary[SerializationKeys.no] = value }
    if let value = code { dictionary[SerializationKeys.code] = value }
    if let value = list { dictionary[SerializationKeys.list] = value.map { $0.dictionaryRepresentation() } }
    if let value = size { dictionary[SerializationKeys.size] = value }
    if let value = total { dictionary[SerializationKeys.total] = value }
    if let value = totalPage { dictionary[SerializationKeys.totalPage] = value }
    if let value = msg { dictionary[SerializationKeys.msg] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.no = aDecoder.decodeObject(forKey: SerializationKeys.no) as? Int
    self.code = aDecoder.decodeObject(forKey: SerializationKeys.code) as? Int
    self.list = aDecoder.decodeObject(forKey: SerializationKeys.list) as? [HotArticleList]
    self.size = aDecoder.decodeObject(forKey: SerializationKeys.size) as? Int
    self.total = aDecoder.decodeObject(forKey: SerializationKeys.total) as? Int
    self.totalPage = aDecoder.decodeObject(forKey: SerializationKeys.totalPage) as? Int
    self.msg = aDecoder.decodeObject(forKey: SerializationKeys.msg) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(no, forKey: SerializationKeys.no)
    aCoder.encode(code, forKey: SerializationKeys.code)
    aCoder.encode(list, forKey: SerializationKeys.list)
    aCoder.encode(size, forKey: SerializationKeys.size)
    aCoder.encode(total, forKey: SerializationKeys.total)
    aCoder.encode(totalPage, forKey: SerializationKeys.totalPage)
    aCoder.encode(msg, forKey: SerializationKeys.msg)
  }

}
