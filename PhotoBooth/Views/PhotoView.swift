//
//  PhotoView.swift
//  PhotoBooth
//
//  Created by Jérémy Rava on 10/06/2024.
//

import SwiftUI
import Photos

struct PhotoView: View {
    var asset: PhotoAsset
    var cache: CachedImageManager?
    var isReader: Bool
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)

    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel(asset.accessibilityLabel)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.secondary)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(!isReader)
        .overlay(alignment: .bottom) {
            if !isReader {
                buttonsView()
                    .offset(x: 0, y: -50)
            }
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }

    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            Button {
                Task {
                    await asset.delete()
                    await MainActor.run {
                        dismiss()
                    }
                }
            } label: {
                Label("Delete", systemImage: "arrowshape.turn.up.backward")
                    .font(.system(size: 24))
            }

            Button {
                Task {
                    print("Ok")
                }
            } label: {
                Label("Ok", systemImage: "checkmark")
                    .font(.system(size: 24))
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
        .background(Color.secondary.colorInvert())
        .cornerRadius(15)
    }
}
