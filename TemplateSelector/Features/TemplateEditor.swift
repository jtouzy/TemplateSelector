//
//  TemplateEditor.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import ComposableArchitecture
import Domain
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
    case changeSelectedElementBackgroundColor(Color)
    case closeTapped
    case elementTapped(Template.Element)
    case removeSelection
  }
}

// MARK: -TemplateEditor.Reducer

extension TemplateEditor {
  static let reducer: Reducer<State, Action, Void> = .init { state, action, _ in
    switch action {
    case .changeSelectedElementBackgroundColor(let backgroundColor):
      state.editedTemplate.updateSelectedElementBackgroundColor(with: backgroundColor)
    case .closeTapped:
      ()
    case .elementTapped(let element):
      state.editedTemplate.selectedElementId = element.id
    case .removeSelection:
      state.editedTemplate.selectedElementId = nil
    }
    return .none
  }
}

// MARK: -TemplateEditor.ViewStore extension

extension ViewStore where State == TemplateEditor.State, Action == TemplateEditor.Action {
  var selectedElementColorBinding: Binding<Color>? {
    guard let selectedElement = state.editedTemplate.selectedElement else {
      return .none
    }
    return binding(
      get: { _ in
        selectedElement.backgroundColor
      },
      send: Action.changeSelectedElementBackgroundColor
    )
  }
}

// MARK: -TemplateEditor.View

private struct UI {
  static let padding: CGFloat = 16.0
  enum BottomEditionToolbar {
    static let height: CGFloat = 100
    static let padding: CGFloat = 16.0
  }
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
        VStack(spacing: UI.padding) {
          TemplateRenderer(
            template: viewStore.editedTemplate,
            onTap: { viewStore.send(.elementTapped($0), animation: .default) }
          )
          bottomEditionToolbar(with: viewStore)
        }
        .padding(UI.padding)
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

@ViewBuilder
private func bottomEditionToolbar(
  with viewStore: ViewStore<TemplateEditor.State, TemplateEditor.Action>
) -> some SwiftUI.View {
  VStack {
    if let selectedElementColorBinding = viewStore.selectedElementColorBinding {
      VStack {
        ColorPicker("Element color", selection: selectedElementColorBinding)
        Divider()
        Button("Remove selection") { viewStore.send(.removeSelection, animation: .default) }
      }
      .padding(UI.BottomEditionToolbar.padding)
    } else {
      Text("Please select a template element")
    }
  }
  .frame(height: UI.BottomEditionToolbar.height)
}
