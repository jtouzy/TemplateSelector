//
//  Combine+extensions.swift
//  AppleExtensions
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import Combine
import Foundation

extension Publisher {
  public func eraseToNSError() -> Publishers.MapError<Self, NSError> {
    mapError { $0 as NSError }
  }
}
