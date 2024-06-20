//
//  OnePictureView.swift
//  PhotoBooth
//
//  Created by Jérémy Rava on 12/06/2024.
//

import SwiftUI
import Photos
import PrintingKit

extension View {
    @MainActor
    func snapshot(scale: CGFloat? = 2.0) -> CGImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale ?? UIScreen.main.scale
        return renderer.cgImage
    }
}

struct OnePictureView: View {
    @StateObject var model: DataModel
    var image: PhotoData?
    @State private var isImageSaved: Bool = false
    @State private var canPrint: Bool = true

    let printer = Printer.shared

    var body: some View {
        let pictureView = createPicture(image: image!.thumbnailImage)

        HStack {
            pictureView

            HStack {
                Button {
                    if let cgImage = pictureView.snapshot() {
                        if let imageData = model.unpackPhotoCGImage(from: cgImage)?.imageData {
                            if !isImageSaved {
                                model.savePhoto(imageData: imageData)
                            }
                            isImageSaved = true
                            let data = PrintItem.imageData(imageData)
                            if printer.canPrint(data) {
                                try? printer.print(data)
                            }
                        }
                    }
                } label: {
                    Label("Imprimer", systemImage: "printer.fill")
                        .font(.system(size: 32))
                }
                .buttonStyle(.plain)
                .labelStyle(.iconOnly)
                .foregroundColor(.blue)
                .padding()
            }
        }
    }
}

private func createPicture(image: Image) -> some View {
    ZStack {
        Image("fond_paysage")
            .resizable()
            .scaledToFit()

        VStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 950, height: 600, alignment: .center)
                .cornerRadius(10)
                .shadow(radius: 10, x: 5, y:5)
                .padding(.top, 30)
            Image("nicolas_25_ans")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 80, alignment: .center)
                .padding(.bottom)
        }
    }
    .frame(height: 760, alignment: .center)
}
