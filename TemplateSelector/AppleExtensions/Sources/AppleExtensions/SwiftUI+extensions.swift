//
//  SwiftUI+extensions.swift
//  AppleExtensions
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import SwiftUI

// MARK: -Color extensions

// NOTE: Extension for Hex/Color conversion
extension Color: RawRepresentable {
  public init?(rawValue: String) {
    var safeHex = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
    safeHex = safeHex.replacingOccurrences(of: "#", with: "")
    var rgb: UInt64 = 0
    var r = CGFloat.zero, g = CGFloat.zero, b = CGFloat.zero
    var a: CGFloat = 1.0
    guard Scanner(string: safeHex).scanHexInt64(&rgb) else {
      return nil
    }
    if safeHex.count == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
    } else if safeHex.count == 8 {
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
    let uiColor = UIColor(self)
    guard let components = uiColor.cgColor.components, components.count >= 3 else {
      return ""
    }
    let r = Float(components[0]), g = Float(components[1]), b = Float(components[2])
    var a = Float(1.0)
    if components.count >= 4 {
      a = Float(components[3])
    }
    if a != 1.0 {
      return String(
        format: "%02lX%02lX%02lX%02lX",
        lroundf(r * 255),
        lroundf(g * 255),
        lroundf(b * 255),
        lroundf(a * 255)
      )
    }
    return String(
      format: "%02lX%02lX%02lX",
      lroundf(r * 255),
      lroundf(g * 255),
      lroundf(b * 255)
    )
  }
}

// MARK: -ContentMode extensions

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

// MARK: -EdgeInsets extensions

extension EdgeInsets {
  public static func uniform(_ value: CGFloat) -> Self {
    .init(top: value, leading: value, bottom: value, trailing: value)
  }
}

// MARK: -View extensions

extension View {
  public func frame(_ size: CGSize) -> some View {
    frame(width: size.width, height: size.height)
  }
}
