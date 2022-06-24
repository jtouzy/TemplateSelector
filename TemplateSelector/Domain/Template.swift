//
//  Template.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import SwiftUI

// MARK: -Template

struct Template: Identifiable, Equatable {
  let id: UUID
  let name: String
  let element: Element
}

// MARK: -Template.Element

extension Template {
  struct Element: Identifiable, Equatable {
    let id: UUID
    let relativePosition: RelativePosition
    let relativeSize: RelativeSize
    let anchorX: AnchorX
    let anchorY: AnchorY
    let relativePadding: EdgeInsets
    let media: Media?
    let children: [Element]
    var backgroundColor: Color
    var isSelected: Bool
  }
}
extension Template.Element {
  func centerPosition(in containerSize: CGSize) -> CGPoint {
    // NOTE: First, the position of the top left angle is evaluated.
    let startPosition: CGPoint = .init(
      x: containerSize.width.value(fromRelative: relativePosition.x),
      y: containerSize.height - containerSize.height.value(fromRelative: relativePosition.y) // NOTE: Y is reverted
    )
    // NOTE: Then, we evaluate the offset depending on Anchor (SwiftUI position is centered, and
    // it's better to evaluate offset directly here, to optimize calculations)
    let middleElementSize = frame(in: containerSize).middle
    return .init(
      x: startPosition.x.offset(value: middleElementSize.width, operation: anchorX.offsetOperation),
      y: startPosition.y.offset(value: middleElementSize.height, operation: anchorY.offsetOperation)
    )
  }
  func frame(in containerSize: CGSize) -> CGSize {
    .init(
      width: containerSize.width.value(fromRelative: relativeSize.width),
      height: containerSize.height.value(fromRelative: relativeSize.height)
    )
  }
  func padding(in containerSize: CGSize) -> EdgeInsets {
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
  struct RelativeSize: Equatable {
    let width: CGFloat
    let height: CGFloat
  }
  struct RelativePosition: Equatable {
    let x: CGFloat
    let y: CGFloat
  }
  enum AnchorX: String, Equatable {
    case left, center, right

    var offsetOperation: ((CGFloat, CGFloat) -> CGFloat)? {
      switch self {
      case .left: return (+)
      case .center: return nil
      case .right: return (-)
      }
    }
  }
  enum AnchorY: String, Equatable {
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
  struct Media: Equatable {
    let name: String
    let contentMode: ContentMode
  }
}
