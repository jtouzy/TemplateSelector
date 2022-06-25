//
//  FoundationTests.swift
//  AppleExtensionsTests
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

@testable import AppleExtensions

import XCTest

final class FoundationTests: XCTestCase {
}

extension FoundationTests {
  private struct DecodeIfPresentWithDefaultValue: Decodable {
    let test: String

    enum CodingKeys: CodingKey {
      case test
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      test = try container.decodeIfPresent(String.self, forKey: .test, withDefaultValue: "DEFAULT")
    }
  }

  func test_keyedDecodingContainer_decodeIfPresentWithDefaultValue_withValue() throws {
    // Given
    let json: String = "{\"test\":\"Value\"}"
    let jsonDecoder = JSONDecoder()
    // When
    let result = try jsonDecoder.decode(DecodeIfPresentWithDefaultValue.self, from: json.data(using: .utf8)!)
    // Then
    XCTAssertEqual(result.test, "Value")
  }
  func test_keyedDecodingContainer_decodeIfPresentWithDefaultValue_withoutValue() throws {
    // Given
    let json: String = "{}"
    let jsonDecoder = JSONDecoder()
    // When
    let result = try jsonDecoder.decode(DecodeIfPresentWithDefaultValue.self, from: json.data(using: .utf8)!)
    // Then
    XCTAssertEqual(result.test, "DEFAULT")
  }
}

extension FoundationTests {
  enum RawRepresented: RawRepresentable {
    case enumCase
    case enumCaseAdditional

    init?(rawValue: Float) {
      switch rawValue {
      case .zero:
        self = .enumCase
      case 1:
        self = .enumCaseAdditional
      default:
        return nil
      }
    }
    var rawValue: Float {
      switch self {
      case .enumCase:
        return .zero
      case .enumCaseAdditional:
        return 1
      }
    }
  }
  private struct DecodeIfPresentWithDefaultValueRawRepresentable: Decodable {
    let raw: RawRepresented

    enum CodingKeys: CodingKey {
      case test
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      raw = try container.decodeIfPresent(RawRepresented.self, forKey: .test, withDefaultValue: .enumCaseAdditional)
    }
  }

  func test_keyedDecodingContainer_decodeIfPresentRawRepresentable_withValue() throws {
    // Given
    let json: String = "{\"test\":0}"
    let jsonDecoder = JSONDecoder()
    // When
    let result = try jsonDecoder.decode(
      DecodeIfPresentWithDefaultValueRawRepresentable.self,
      from: json.data(using: .utf8)!
    )
    // Then
    XCTAssertEqual(result.raw, .enumCase)
  }
  func test_keyedDecodingContainer_decodeIfPresentRawRepresentable_withoutValue() throws {
    // Given
    let json: String = "{}"
    let jsonDecoder = JSONDecoder()
    // When
    let result = try jsonDecoder.decode(
      DecodeIfPresentWithDefaultValueRawRepresentable.self,
      from: json.data(using: .utf8)!
    )
    // Then
    XCTAssertEqual(result.raw, .enumCaseAdditional)
  }
}
