//
//  Cameraview.swift
//  PhotoBooth
//
//  Created by Jérémy Rava on 10/06/2024.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = DataModel()
    @State private var delayCount: Int = 0
    @State private var retry: Bool = false
    @State var numberOfPhotos: Int
    @State private var showImageTaken: Bool = false
    @State private var countPhotos: Int = 0
    @State var imagesData: [PhotoData] = []
    @State private var heartPulse: CGFloat = 1

    var body: some View {
        VStack {
            ViewfinderView(image:  $model.viewfinderImage)
                .background(Color.customGray)
                .overlay(alignment: .center) {
                    if delayCount > 0 && !retry {
                        Text("\(delayCount)")
                            .foregroundStyle(Color.white)
                            .font(.custom("Impact", size: 200))
                            .opacity(0.7)
                    } else {
                        buttonTakePhoto()
                            .opacity(0.7)
                    }
                }
                .overlay(alignment: .leading) {
                    if delayCount != 0 && !retry {
                        HStack {
                            Image(systemName: "arrowshape.left.fill")
                                .foregroundColor(Color.white)
                                .font(.system(size: 50))
                            Text("Regardez ici !")
                                .foregroundColor(Color.white)
                                .font(.title)

                        }
                        .offset(x: heartPulse)
                        .onAppear{
                            heartPulse = 1
                            withAnimation(.easeInOut.repeatForever(autoreverses: true)) {
                                heartPulse = 20 * heartPulse
                            }
                        }
                        .opacity(0.7)
                    }
                }

                .overlay(alignment: .bottom) {
                    buttonsView()
                }
                .task {
                    await model.camera.start()
                    await model.loadPhotos()
                    await model.loadThumbnail()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(model.showPreview)
                .ignoresSafeArea()
                .statusBar(hidden: true)

                .overlay(alignment: .center) {
                    previewImage()
                }

                .overlay(alignment: .center) {
                    collageView()
                }
        }
    }

    private func buttonTakePhoto() -> some View {
        Button {
            delayCount = 10
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                delayCount -= 1
                if delayCount == 0 && !retry {
                    timer.invalidate()
                    model.camera.takePhoto()
                    showImageTaken = true
                } else if retry {
                    timer.invalidate()
                    retry = false
                    delayCount = 0
                }
            }
        } label: {
            Label {
                Text("Take Photo")
            } icon: {
                ZStack {
                    Circle()
                        .strokeBorder(.white, lineWidth: 3)
                        .frame(width: 124, height: 124)
                    Circle()
                        .fill(.white)
                        .frame(width: 100, height: 100)
                }
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .disabled(delayCount > 0)
    }

    private func buttonsView() -> some View {
        HStack(spacing: 60) {

            Spacer()
            NavigationLink {
                PhotoCollectionView(photoCollection: model.photoCollection)
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }.disabled(delayCount > 0 && !retry)

            Button {
                retry = true
            } label: {
                Label("Retry", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 62, weight: .bold))
                    .foregroundColor(.white)
            }
            .disabled(delayCount == 0 || retry)

            Spacer()
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(30)
    }

    private func previewImage() -> some View {
        ZStack {
            if model.showPreview {
                Color.white

                if let image = model.images.last?.thumbnailImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .overlay(alignment: .bottom) {
                            HStack(spacing: 60) {
                                Button {
                                    Task {
                                        await model.loadThumbnail()
                                    }
                                    model.images.removeLast()
                                    model.showPreview = false
                                } label: {
                                    Label("Delete", systemImage: "arrowshape.turn.up.backward")
                                        .font(.system(size: 32))
                                }

                                Button {
                                    countPhotos += 1
                                    if countPhotos == numberOfPhotos {
                                        for data in model.images {
                                            imagesData.append(data)
                                        }
                                    }
                                    model.showPreview = false
                                } label: {
                                    Label("Ok", systemImage: "checkmark")
                                        .font(.system(size: 32))
                                }
                            }
                            .buttonStyle(.plain)
                            .labelStyle(.iconOnly)
                            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
                            .background(Color.secondary.colorInvert())
                            .cornerRadius(15)
                            .offset(x: 0, y: -50)
                        }
                        .onAppear {
                            model.camera.isPreviewPaused = true
                        }
                        .onDisappear {
                            model.camera.isPreviewPaused = false
                        }
                }
            }
        }
    }

    private func collageView() -> some View {
        VStack {
            if !model.showPreview && numberOfPhotos == imagesData.count {
                HStack {
                    Spacer()
                    if numberOfPhotos == 1 {
                        OnePictureView(model: model, image: imagesData.first)
                    } else {
                        TwoPicturesView(model: model, image1: imagesData.first, image2: imagesData.last)
                    }
                    Spacer()
                }
                .background(Color.customGray)
                .onAppear {
                    model.camera.isPreviewPaused = true
                }
                .onDisappear {
                    model.camera.isPreviewPaused = false
                }
            }
        }
    }
}

#Preview {
    CameraView(numberOfPhotos: 1)
}
