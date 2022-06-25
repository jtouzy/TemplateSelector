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
  public var element: Element
  public var selectedElementId: Element.ID?

  public var selectedElement: Element? {
    guard let selectedElementId = selectedElementId else {
      return nil
    }
    return findElement(in: element, identifiedBy: selectedElementId)
  }

  public init(id: UUID, name: String, element: Element, selectedElementId: Element.ID?) {
    self.id = id
    self.name = name
    self.element = element
    self.selectedElementId = selectedElementId
  }
}

// MARK: -Template Element tree search

private func findElement(in element: Template.Element, identifiedBy elementId: Template.Element.ID) -> Template.Element? {
  guard element.id == elementId else {
    for child in element.children {
      if let retrieved = findElement(in: child, identifiedBy: elementId) {
        return retrieved
      }
    }
    return nil
  }
  return element
}

// MARK: -Template updates

extension Template {
  public mutating func updateSelectedElementBackgroundColor(with color: Color) {
    guard let selectedElementId = selectedElementId else {
      return
    }
    element.updateBackgroundColor(with: color, forElementId: selectedElementId)
  }
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
    public var children: [Element]
    public var backgroundColor: Color

    public init(
      id: UUID,
      relativePosition: RelativePosition = .init(x: .zero, y: .zero),
      relativeSize: RelativeSize,
      anchorX: AnchorX = .left,
      anchorY: AnchorY = .bottom,
      relativePadding: EdgeInsets = .uniform(.zero),
      media: Media? = nil,
      children: [Element] = [],
      backgroundColor: Color
    ) {
      self.id = id
      self.relativePosition = relativePosition
      self.relativeSize = relativeSize
      self.anchorX = anchorX
      self.anchorY = anchorY
      self.relativePadding = relativePadding
      self.media = media
      self.children = children
      self.backgroundColor = backgroundColor
    }
  }
}

// MARK: -Template.Element updates

extension Template.Element {
  mutating func updateBackgroundColor(with color: Color, forElementId elementId: Template.Element.ID) {
    guard elementId == id else {
      updateBackgroundColorInChildren(with: color, forElementId: elementId)
      return
    }
    backgroundColor = color
  }
  private mutating func updateBackgroundColorInChildren(
    with color: Color,
    forElementId elementId: Template.Element.ID
  ) {
    children = children.map { child in
      var updatedChild = child
      updatedChild.updateBackgroundColor(with: color, forElementId: elementId)
      return updatedChild
    }
  }
}

// MARK: -Template.Element SwiftUI layout functions

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

    public init(width: CGFloat, height: CGFloat) {
      self.width = width
      self.height = height
    }
  }
  public struct RelativePosition: Equatable {
    public let x: CGFloat
    public let y: CGFloat

    public init(x: CGFloat, y: CGFloat) {
      self.x = x
      self.y = y
    }
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
