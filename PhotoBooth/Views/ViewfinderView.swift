//
//  ViewfinderView.swift
//  PhotoBooth
//
//  Created by Jérémy Rava on 10/06/2024.
//

import SwiftUI

struct ViewfinderView: View {
    @Binding var image: Image?

    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    ViewfinderView(image: .constant(Image(systemName: "pencil")))
}
