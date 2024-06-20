//
//  ThumbnailView.swift
//  PhotoBooth
//
//  Created by Jérémy Rava on 10/06/2024.
//

import SwiftUI

struct ThumbnailView: View {
    var image: Image?

    var body: some View {
        ZStack {
            Color.white
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 62, height: 62)
        .cornerRadius(11)
    }
}

#Preview {
    ThumbnailView(image: Image(systemName: "photo.fill"))
}
