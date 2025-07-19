//
//  MaterialSelectorTextField.swift
//  EliteMonitor
//
//  Created by Andrew Childs on 2025/07/13.
//

import EliteGameData
import SwiftUI

import protocol EliteGameData.Material

struct MaterialSelectorTextField: NSViewRepresentable {
  let material: Binding<AnyMaterial?>
  let onSubmit: () -> Void

  class Coordinator: NSObject, NSTextSuggestionsDelegate, NSTextFieldDelegate, NSControlTextEditingDelegate {
    let material: Binding<AnyMaterial?>
    var onSubmit: () -> Void

    init(material: Binding<AnyMaterial?>, onSubmit: @escaping () -> Void) {
      self.material = material
      self.onSubmit = onSubmit
    }

    typealias SuggestionItemType = AnyMaterial

    func textField(_ textField: NSTextField, provideUpdatedSuggestions responseHandler: @escaping (ItemResponse) -> Void) {
      func matching<T: Material & CaseIterable>(_ title: LocalizedStringResource, _ type: T.Type) -> ItemSection {
        let items = T.allCases.compactMap { m -> Item? in
          guard m.localizedName.localizedCaseInsensitiveContains(textField.stringValue) else { return nil }
          return Item(
            representedValue: m.asAnyMaterial,
            title: m.localizedName
          )
        }

        return ItemSection(title: String(localized: title), items: items)
      }

      let sections: [ItemSection] = [
        matching("Raw", RawMaterial.self),
        matching("Manufactured", ManufacturedMaterial.self),
        matching("Encoded", EncodedMaterial.self),
      ]

      responseHandler(ItemResponse(itemSections: sections))
    }

    func textField(_ textField: NSTextField, didSelect item: Item) {
      textField.stringValue = item.representedValue.localizedName
      onSubmit()
    }

    func controlTextDidEndEditing(_ obj: Notification) {
      let textField = obj.object as! NSTextField

      guard let material = currentMaterial(textField.stringValue) else {
        textField.stringValue = ""
        return
      }

      textField.stringValue = material.localizedName
      self.material.wrappedValue = material
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
      switch commandSelector {
      case #selector(NSStandardKeyBindingResponding.insertNewline(_:)):
        onSubmit()
        return true
      case #selector(NSStandardKeyBindingResponding.cancelOperation(_:)):
        control.stringValue = ""
        return true
      default:
        return false
      }
    }

    func currentMaterial(_ partial: String) -> AnyMaterial? {
      findMaterial(partial, ofType: RawMaterial.self) ??
        findMaterial(partial, ofType: ManufacturedMaterial.self) ??
        findMaterial(partial, ofType: EncodedMaterial.self)
    }

    private func findMaterial<T: Material & CaseIterable>(_ string: String, ofType: T.Type) -> AnyMaterial? {
      T.allCases.first { m in
        m.localizedName.localizedCaseInsensitiveContains(string)
      }?.asAnyMaterial
    }
  }

  func makeCoordinator() -> Coordinator {
    .init(material: material, onSubmit: onSubmit)
  }

  func makeNSView(context: Context) -> NSTextField {
    let view = NSTextField()
    if let material = material.wrappedValue {
      view.stringValue = material.localizedName
    }

    view.suggestionsDelegate = context.coordinator
    view.delegate = context.coordinator

    return view
  }

  func updateNSView(_ nsView: NSTextField, context: Context) {
    context.coordinator.onSubmit = onSubmit

    let newStringValue = if let material = material.wrappedValue {
      material.localizedName
    } else {
      ""
    }
    nsView.stringValue = newStringValue
  }

  typealias NSViewType = NSTextField
}
