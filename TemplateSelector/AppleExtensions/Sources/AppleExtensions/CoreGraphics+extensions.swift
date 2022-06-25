//
//  CoreGraphics+extensions.swift
//  AppleExtensions
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import CoreGraphics

// MARK: -CGFloat extensions

extension CGFloat {
  public func value(fromRelative relativeValue: CGFloat) -> CGFloat {
    self * relativeValue
  }

  public typealias OffsetOperation = (CGFloat, CGFloat) -> CGFloat
  public func offset(value: CGFloat, operation: OffsetOperation? = nil) -> CGFloat {
    operation?(self, value) ?? self
  }
}

// MARK: -CGSize extensions

extension CGSize {
  public var middle: CGSize {
    .init(width: width / 2, height: height / 2)
  }
}
