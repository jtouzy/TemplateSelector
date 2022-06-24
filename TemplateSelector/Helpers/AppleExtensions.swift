//
//  AppleExtensions.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import Combine
import SwiftUI

// MARK: -Combine extensions

extension Publisher {
  func eraseToNSError() -> Publishers.MapError<Self, NSError> {
    mapError { $0 as NSError }
  }
}

// MARK: -CoreGraphics extensions

extension CGFloat {
  func value(fromRelative relativeValue: CGFloat) -> CGFloat {
    self * relativeValue
  }
}
extension CGSize {
  var middle: CGSize {
    .init(width: width / 2, height: height / 2)
  }
}

// MARK: -Foundation extensions

extension KeyedDecodingContainer {
  func decodeIfPresent<T>(_ type: T.Type, forKey key: Key, withDefaultValue default: T) throws -> T
  where T: Decodable {
    try decodeIfPresent(T.self, forKey: key) ?? `default`
  }
  func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T?
  where T: RawRepresentable, T.RawValue: Decodable {
    guard let rawValue = try decodeIfPresent(T.RawValue.self, forKey: key) else {
      return nil
    }
    return T(rawValue: rawValue)
  }
  func decodeIfPresent<T>(_ type: T.Type, forKey key: Key, withDefaultValue default: T) throws -> T
  where T: RawRepresentable, T.RawValue: Decodable {
    try decodeIfPresent(type, forKey: key) ?? `default`
  }
}

// MARK: -SwiftUI extensions

// NOTE: Dumb Stack extension for Hex/Color conversion, refacto later
extension Color: RawRepresentable {
  public init?(rawValue: String) {
    var hexSanitized = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    var rgb: UInt64 = 0
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0
    let length = hexSanitized.count

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
    } else if length == 8 {
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
    } else {
      return nil
    }
    self = .init(red: r, green: g, blue: b, opacity: a)
  }
  public var rawValue: String {
    let uic = UIColor(self)
    guard let components = uic.cgColor.components, components.count >= 3 else {
      return ""
    }
    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])
    var a = Float(1.0)

    if components.count >= 4 {
      a = Float(components[3])
    }

    if a != Float(1.0) {
      return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    } else {
      return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
  }
}

extension ContentMode: RawRepresentable {
  public init?(rawValue: String) {
    switch rawValue {
    case "fit":
      self = .fit
    case "fill":
      self = .fill
    default:
      return nil
    }
  }
  public var rawValue: String {
    switch self {
    case .fit: return "fit"
    case .fill: return "fill"
    }
  }
}

extension EdgeInsets {
  static func uniform(_ value: CGFloat) -> Self {
    .init(top: value, leading: value, bottom: value, trailing: value)
  }
}

extension View {
  func frame(_ size: CGSize) -> some View {
    frame(width: size.width, height: size.height)
  }
}
