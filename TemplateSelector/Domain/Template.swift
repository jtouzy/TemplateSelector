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
    let middleElementSize = frame(in: containerSize).middle
    let startPosition: CGPoint = .init(
      x: containerSize.width.value(fromRelative: relativePosition.x),
      y: containerSize.height.value(fromRelative: relativePosition.y)
    )
    return .init(
      x: startPosition.x + middleElementSize.width,
      y: startPosition.y + middleElementSize.height
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
  }
  enum AnchorY: String, Equatable {
    case bottom, center, top
  }
}

// MARK: -Template.Element.Media type

extension Template.Element {
  struct Media: Equatable {
    let name: String
    let contentMode: ContentMode
  }
}
