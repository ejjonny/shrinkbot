//
//  UIConstants.swift
//  shrinkbot
//
//  Created by Ethan John on 2/8/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI

struct ShrinkFont: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    init(size: CGFloat, weight: Font.Weight) {
        self.size = size
        self.weight = weight
    }
    func body(content: Content) -> some View {
        return content
            .font(.system(size: size, weight: weight, design: .rounded))
    }
}

extension View {
    func defaultFont(_ size: CGFloat = 13, weight: Font.Weight = .medium) -> some View {
        self.modifier(ShrinkFont(size: size, weight: weight))
    }
}

extension Animation {
    static func shrinkbotSpring() -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(3)
    }
}

struct OpenTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var shouldBeFirstResponder: Bool
    var onChanged: ((String) -> ())?
    var onCommit: (() -> ())?
    var placeHolder: String
    var fontSize: CGFloat
    var weight: Font.Weight
    var initialValue: String
    
    init(_ placeHolder: String = "", initialValue: String = "", fontSize: CGFloat = 13, weight: Font.Weight = .regular, text: Binding<String>, shouldBeFirstResponder: Binding<Bool> = Binding(get: { false }, set: { newValue in }), onChanged: ((String) -> ())? = nil, onCommit: (() -> ())? = nil) {
        self.onChanged = onChanged
        self.onCommit = onCommit
        self.placeHolder = placeHolder
        _text = text
        self.initialValue = initialValue
        self.fontSize = fontSize
        self.weight = weight
        _shouldBeFirstResponder = shouldBeFirstResponder
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.delegate = context.coordinator
        view.placeholder = placeHolder
        var uiKitWeight: UIFont.Weight = .regular
        switch weight {
        case .black:
            uiKitWeight = .black
        case .bold:
            uiKitWeight = .bold
        case .heavy:
            uiKitWeight = .heavy
        case .light:
            uiKitWeight = .light
        case .medium:
            uiKitWeight = .medium
        case .regular:
            uiKitWeight = .regular
        case .semibold:
            uiKitWeight = .semibold
        case .thin:
            uiKitWeight = .thin
        case .ultraLight:
            uiKitWeight = .ultraLight
        default:
            uiKitWeight = .regular
        }
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: uiKitWeight)
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            view.font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            view.font = systemFont
        }
        view.text = initialValue
        view.textAlignment = .center
        return view
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if shouldBeFirstResponder && !uiView.isFirstResponder{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
                uiView.becomeFirstResponder()
            }
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: OpenTextField
        init(_ parent: OpenTextField) {
            self.parent = parent
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard textField.text != nil,
                let range = Range(range, in: textField.text!)
                else { assertionFailure() ; return false }
            var text = textField.text!
            text.replaceSubrange(range, with: string)
            parent.text = text
            parent.onChanged?(text)
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.onCommit?()
        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            parent.shouldBeFirstResponder
        }
    }
}

extension View {
    func open(_ mod: @escaping (UITextField) -> (UITextField)) -> some View {
        return EmptyView()
    }
}
