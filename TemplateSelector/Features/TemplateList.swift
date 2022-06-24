//
//  TemplateList.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import SwiftUI

// MARK: -TemplateList.ViewModel

struct TemplateList {
  class ViewModel: ObservableObject {
    typealias FetchTemplates = () async throws -> [Template]

    @Published var state: State
    @Published var selectedTemplate: Template?

    private var fetchTemplates: FetchTemplates

    init(state: State = .loadingTemplates, fetchTemplates: @escaping FetchTemplates) {
      self.state = state
      self.fetchTemplates = fetchTemplates
    }

    func fetchTemplatesOnAppear() async {
      do {
        let templates = try await fetchTemplates()
        await MainActor.run {
          self.state = .displayed(data: templates)
        }
      } catch {
        await MainActor.run {
          self.state = .loadingFailure
        }
      }
    }
  }
}
extension TemplateList {
  enum State {
    case loadingTemplates
    case displayed(data: [Template])
    case loadingFailure
  }
}

// MARK: -TemplateList.View

private struct UI {
  struct Grid {
    static let numberOfColumns: Int = 3
    static let columns: [SwiftUI.GridItem] = {
      (0..<numberOfColumns).map { _ in .init() }
    }()
    static let padding = UI.GridItem.padding
  }
  struct GridItem {
    static let height: CGFloat = 150
    static let padding: CGFloat = 16.0

    static func frame(in containerSize: CGSize) -> CGSize {
      let totalInnerPadding = (CGFloat(UI.Grid.numberOfColumns) - 1) * padding
      let availableWidthInContainer = containerSize.width - totalInnerPadding
      return .init(
        width: availableWidthInContainer / CGFloat(UI.Grid.numberOfColumns),
        height: height
      )
    }
  }
}

extension TemplateList {
  struct View: SwiftUI.View {
    @ObservedObject var viewModel: TemplateList.ViewModel

    var body: some SwiftUI.View {
      NavigationView {
        stateBasedView(
          using: viewModel.state
        )
        .navigationTitle("Choose a template")
      }
      .onAppear {
        Task {
          await viewModel.fetchTemplatesOnAppear()
        }
      }
    }
  }
}

@ViewBuilder
private func stateBasedView(using state: TemplateList.State) -> some View {
  switch state {
  case .loadingTemplates:
    ProgressView()
  case .displayed(let data):
    templateListView(using: data)
  case .loadingFailure:
    Text("Failure!")
  }
}

@ViewBuilder
private func templateListView(using templates: [Template]) -> some View {
  GeometryReader { proxy in
    ScrollView {
      LazyVGrid(columns: UI.Grid.columns, spacing: .zero) {
        ForEach(templates) { template in
          TemplateRenderer(template: template)
            .frame(UI.GridItem.frame(in: proxy.size))
        }
      }
    }
  }
  .padding(UI.Grid.padding)
}
