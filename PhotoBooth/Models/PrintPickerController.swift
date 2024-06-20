//
//  PrintPickerController.swift
//  PhotoBooth
//
//  Created by Jérémy Rava on 12/06/2024.
//

import Foundation

struct PrinterPickerController: UIViewControllerRepresentable {
    @Binding var showPrinterPicker: Bool

    fileprivate let controller = UIViewController()

    func makeUIViewController(context: Context) -> UIViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showPrinterPicker && context.coordinator.activePicker == nil {
            let picker = UIPrinterPickerController(initiallySelectedPrinter: nil)
            context.coordinator.activePicker = picker

            picker.delegate = context.coordinator
            picker.present(animated: true) { (picker, flag, error) in
                if let printer =  picker.selectedPrinter {
                        // << do anything needed with printer
                }

                context.coordinator.activePicker = nil
                self.showPrinterPicker = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIPrinterPickerControllerDelegate {
        let owner: PrinterPickerController
        var activePicker: UIPrinterPickerController?

        init(_ owner: PrinterPickerController) {
            self.owner = owner
        }

        func printerPickerControllerParentViewController(_ printerPickerController: UIPrinterPickerController) -> UIViewController? {
            self.owner.controller
        }
    }

    typealias UIViewControllerType = UIViewController
}
