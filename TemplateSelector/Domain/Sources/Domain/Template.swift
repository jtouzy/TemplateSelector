//
//  Template.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import AppleExtensions
import SwiftUI

// MARK: -Template

public struct Template: Identifiable, Equatable {
  public let id: UUID
  public let name: String
  public let element: Element
}

// MARK: -Template.Element

extension Template {
  public struct Element: Identifiable, Equatable {
    public let id: UUID
    public let relativePosition: RelativePosition
    public let relativeSize: RelativeSize
    public let anchorX: AnchorX
    public let anchorY: AnchorY
    public let relativePadding: EdgeInsets
    public let media: Media?
    public let children: [Element]
    public var backgroundColor: Color
    public var isSelected: Bool
  }
}
extension Template.Element {
  public func swiftUIPosition(in containerSize: CGSize) -> CGPoint {
    // NOTE: First, the position of the top left angle is evaluated.
    let startPosition: CGPoint = .init(
      x: containerSize.width.value(fromRelative: relativePosition.x),
      y: containerSize.height - containerSize.height.value(fromRelative: relativePosition.y) // NOTE: Y is reverted
    )
    // NOTE: Then, we evaluate the offset depending on Anchor (SwiftUI position is centered, and
    // it's better to evaluate offset directly here, to optimize calculations)
    let middleElementSize = swiftUIFrame(in: containerSize).middle
    return .init(
      x: startPosition.x.offset(value: middleElementSize.width, operation: anchorX.offsetOperation),
      y: startPosition.y.offset(value: middleElementSize.height, operation: anchorY.offsetOperation)
    )
  }
  public func swiftUIFrame(in containerSize: CGSize) -> CGSize {
    .init(
      width: containerSize.width.value(fromRelative: relativeSize.width),
      height: containerSize.height.value(fromRelative: relativeSize.height)
    )
  }
  public func swiftUIPadding(in containerSize: CGSize) -> EdgeInsets {
    .init(
      top: containerSize.height.value(fromRelative: relativePadding.top),
      leading: containerSize.width.value(fromRelative: relativePadding.leading),
      bottom: containerSize.height.value(fromRelative: relativePadding.bottom),
      trailing: containerSize.width.value(fromRelative: relativePadding.trailing)
    )
  }
}

// MARK: -Template.Element layout types

extension Template.Element {
  public struct RelativeSize: Equatable {
    public let width: CGFloat
    public let height: CGFloat
  }
  public struct RelativePosition: Equatable {
    public let x: CGFloat
    public let y: CGFloat
  }
  public enum AnchorX: String, Equatable {
    case left, center, right

    var offsetOperation: ((CGFloat, CGFloat) -> CGFloat)? {
      switch self {
      case .left: return (+)
      case .center: return nil
      case .right: return (-)
      }
    }
  }
  public enum AnchorY: String, Equatable {
    case bottom, center, top

    var offsetOperation: ((CGFloat, CGFloat) -> CGFloat)? {
      switch self {
      case .top: return (+)
      case .center: return nil
      case .bottom: return (-)
      }
    }
  }
}

// MARK: -Template.Element.Media type

extension Template.Element {
  public struct Media: Equatable {
    public let name: String
    public let contentMode: ContentMode
  }
}
