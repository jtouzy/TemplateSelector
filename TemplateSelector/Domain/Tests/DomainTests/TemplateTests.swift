//
//  TemplateTests.swift
//  DomainTests
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

@testable import Domain

import SwiftUI
import XCTest

final class TemplateTests: XCTestCase {
  private func createSUT(
    relativePosition: Template.Element.RelativePosition,
    relativeSize: Template.Element.RelativeSize,
    anchorX: Template.Element.AnchorX = .left,
    anchorY: Template.Element.AnchorY = .bottom,
    relativePadding: EdgeInsets = .uniform(.zero)
  ) -> Template.Element {
    .init(
      id: .init(),
      relativePosition: relativePosition,
      relativeSize: relativeSize,
      anchorX: anchorX,
      anchorY: anchorY,
      relativePadding: relativePadding,
      media: nil,
      children: [],
      backgroundColor: .clear,
      isSelected: false
    )
  }
}

extension TemplateTests {
  func test_swiftUIPosition_happyPath() {
    // Given
    let containerSize: CGSize = .init(width: 1_000, height: 1_000)
    let sut: Template.Element = createSUT(
      relativePosition: .init(x: 0.2, y: 0.5),
      relativeSize: .init(width: 0.5, height: 0.5),
      anchorX: .left,
      anchorY: .bottom
    )
    // When
    let position = sut.swiftUIPosition(in: containerSize)
    // Then
    XCTAssertEqual(position, .init(x: 450, y: 250))
  }
  func test_swiftUIPosition_centerXTopY() {
    // Given
    let containerSize: CGSize = .init(width: 1_000, height: 1_000)
    let sut: Template.Element = createSUT(
      relativePosition: .init(x: 0.2, y: 0.5),
      relativeSize: .init(width: 0.5, height: 0.5),
      anchorX: .center,
      anchorY: .top
    )
    // When
    let position = sut.swiftUIPosition(in: containerSize)
    // Then
    XCTAssertEqual(position, .init(x: 200, y: 750))
  }
}

extension TemplateTests {
  func test_swiftUIFrame() {
    // Given
    let containerSize: CGSize = .init(width: 1_000, height: 1_000)
    let sut: Template.Element = createSUT(
      relativePosition: .init(x: 0.2, y: 0.5),
      relativeSize: .init(width: 0.5, height: 0.5)
    )
    // When
    let frame = sut.swiftUIFrame(in: containerSize)
    // Then
    XCTAssertEqual(frame, .init(width: 500, height: 500))
  }
}

extension TemplateTests {
  func test_swiftUIPadding() {
    // Given
    let containerSize: CGSize = .init(width: 1_000, height: 1_000)
    let sut: Template.Element = createSUT(
      relativePosition: .init(x: 0.2, y: 0.5),
      relativeSize: .init(width: 0.5, height: 0.5),
      relativePadding: .uniform(0.1)
    )
    // When
    let padding = sut.swiftUIPadding(in: containerSize)
    // Then
    XCTAssertEqual(padding, .uniform(100))
  }
}
