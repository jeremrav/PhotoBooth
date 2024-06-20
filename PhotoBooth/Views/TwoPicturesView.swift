//
//  TwoPicturesView.swift
//  PhotoBooth
//
//  Created by Jérémy Rava on 12/06/2024.
//

import SwiftUI
import Photos
import PrintingKit

struct TwoPicturesView: View {
    @StateObject var model: DataModel
    var image1: PhotoData?
    var image2: PhotoData?
    @State private var isImageSaved: Bool = false

    let printer = Printer.shared

    var body: some View {
        let pictureView = createPicture(image1: image1!.thumbnailImage, image2: image2!.thumbnailImage)

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

private func createPicture(image1: Image, image2: Image) -> some View {
    ZStack {
        Image("fond_portrait")
            .resizable()
            .scaledToFit()

        VStack {
            image1
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 425, height: 300, alignment: .center)
                .cornerRadius(10)
                .shadow(radius: 10, x: 5, y:5)
                .padding(.top, 30)
            image2
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 425, height: 300, alignment: .center)
                .cornerRadius(10)
                .shadow(radius: 10, x: 5, y:5)
                .padding(.top, 10)
            Image("nicolas_25_ans")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 80, alignment: .center)
                .padding(.bottom)
        }
    }
    .frame(height: 760, alignment: .center)
}
