//
//  KeyboardResponsive.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/13/23.
//

import Foundation
import SwiftUI

struct KeyboardResponsiveModifier: ViewModifier {
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(y: -offset)
            .onAppear {
                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillShowNotification,
                    object: nil, queue: .main) { notification in
                        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
                        offset = keyboardSize.height
                    }

                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillHideNotification,
                    object: nil, queue: .main) { _ in
                        offset = 0
                    }
            }
    }
}
