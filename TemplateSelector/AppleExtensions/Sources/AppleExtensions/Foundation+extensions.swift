//
//  Foundation+extensions.swift
//  AppleExtensions
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import Foundation

extension KeyedDecodingContainer {
  public func decodeIfPresent<T>(_ type: T.Type, forKey key: Key, withDefaultValue default: T) throws -> T
  where T: Decodable {
    try decodeIfPresent(T.self, forKey: key) ?? `default`
  }
  public func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T?
  where T: RawRepresentable, T.RawValue: Decodable {
    guard let rawValue = try decodeIfPresent(T.RawValue.self, forKey: key) else {
      return nil
    }
    return T(rawValue: rawValue)
  }
  public func decodeIfPresent<T>(_ type: T.Type, forKey key: Key, withDefaultValue default: T) throws -> T
  where T: RawRepresentable, T.RawValue: Decodable {
    try decodeIfPresent(type, forKey: key) ?? `default`
  }
}
