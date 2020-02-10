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
    var onChanged: ((String) -> ())?
    var onCommit: (() -> ())?
    var placeHolder: String
    
    init(_ placeHolder: String, text: Binding<String>, onChanged: ((String) -> ())? = nil, onCommit: (() -> ())? = nil) {
        self.onChanged = onChanged
        self.onCommit = onCommit
        self.placeHolder = placeHolder
        _text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.delegate = context.coordinator
        view.placeholder = placeHolder
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            view.becomeFirstResponder()
        }
        return view
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
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
    }
}

extension View {
    func open(_ mod: @escaping (UITextField) -> (UITextField)) -> some View {
        return EmptyView()
    }
}
