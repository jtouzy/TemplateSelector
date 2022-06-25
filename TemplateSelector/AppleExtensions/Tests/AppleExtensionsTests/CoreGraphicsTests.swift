//
//  CoreGraphicsTests.swift
//  AppleExtensionsTests
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

@testable import AppleExtensions

import XCTest

final class CoreGraphicsTests: XCTestCase {
  func test_cgFloat_value_relative() {
    // Given
    let sut: CGFloat = 1_000
    let relativeValue: CGFloat = 0.4
    // When
    let result = sut.value(fromRelative: relativeValue)
    // Then
    XCTAssertEqual(result, 400)
  }
  func test_cgFloat_offset_withOperation() {
    // Given
    let sut: CGFloat = 1_000
    let additionalValue: CGFloat = 500
    // When
    let result = sut.offset(value: additionalValue, operation: +)
    // Then
    XCTAssertEqual(result, 1_500)
  }
  func test_cgFloat_offset_withoutOperation() {
    // Given
    let sut: CGFloat = 1_000
    let additionalValue: CGFloat = 500
    // When
    let result = sut.offset(value: additionalValue)
    // Then
    XCTAssertEqual(result, 1_000)
  }
  func test_cgSize_middle() {
    // Given
    let sut: CGSize = .init(width: 1_000, height: 2_000)
    // When
    let result = sut.middle
    // Then
    XCTAssertEqual(result, .init(width: 500, height: 1_000))
  }
}
