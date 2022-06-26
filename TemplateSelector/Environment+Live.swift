//
//  Environment+Live.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import ComposableArchitecture
import Domain
import SwiftUI

extension Main.Environment {
  static let live: Self = .init(
    fetchTemplates: fetchTemplatesHandler()
  )
}


private func fetchTemplatesHandler() -> Main.Environment.FetchTemplates {
  return {
    Effect.task {
      try await TemplateService.live.fetchTemplates()
    }
    .eraseToNSError()
    .catchToEffect()
  }
}
