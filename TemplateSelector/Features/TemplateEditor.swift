//
//  TemplateEditor.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import ComposableArchitecture
import SwiftUI

enum TemplateEditor {
}

// MARK: -TemplateEditor.State

extension TemplateEditor {
  struct State: Equatable {
    var editedTemplate: Template
  }
}

// MARK: -TemplateEditor.Action

extension TemplateEditor {
  enum Action {
    case closeTapped
  }
}

// MARK: -TemplateEditor.Reducer

extension TemplateEditor {
  static let reducer: Reducer<State, Action, Void> = .init { state, action, _ in
    return .none
  }
}

// MARK: -TemplateEditor.View

private struct UI {
}

extension TemplateEditor {
  struct View: SwiftUI.View {
    let store: Store<State, Action>
    @ObservedObject var viewStore: ViewStore<State, Action>

    init(store: Store<State, Action>) {
      self.store = store
      self.viewStore = ViewStore(store)
    }

    var body: some SwiftUI.View {
      NavigationView {
        VStack {
          TemplateRenderer(template: viewStore.editedTemplate, onTap: { _ in })
            .padding(16.0)
        }
        .navigationTitle("Template Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Close") { viewStore.send(.closeTapped) }
          }
        }
      }
    }
  }
}
