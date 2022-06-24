//
//  TemplateSelectorApp.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import ComposableArchitecture
import SwiftUI

@main
struct TemplateSelectorApp: App {
  var body: some Scene {
    WindowGroup {
      Main.View(
        store: .init(
          initialState: .initial,
          reducer: Main.reducer,
          environment: .live
        )
      )
    }
  }
}
