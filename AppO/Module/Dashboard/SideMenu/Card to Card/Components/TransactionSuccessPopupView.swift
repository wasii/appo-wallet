//
//  TransactionSuccessPopupView.swift
//  AppO
//
//  Created by Abul Jaleel on 09/10/2024.
//

import SwiftUI

struct TransactionSuccessPopupView: View {
    var paidTo: String
    @State private var isSharing = false
    @State private var snapshotImage: UIImage? = nil
    
    var closure: () -> ()
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("Transaction Details")
                .font(AppFonts.bodyTwentyTwoBold)
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.appBlue)
                )
            
            Text("Paid to \(paidTo)")
                .font(AppFonts.bodyTwentyTwoBold)
                .foregroundStyle(.appBlue)
                .frame(width: 250)
                .frame(height: 60)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 10) {
                TransactionSuccessPopupDetailView(title: "Transaction No", description: "000000000786")
                TransactionSuccessPopupDetailView(title: "Transaction Time", description: "01:32:51")
                TransactionSuccessPopupDetailView(title: "Transaction Date", description: "27-Sep-2024")
                TransactionSuccessPopupDetailView(title: "Currency", description: "USD")
                TransactionSuccessPopupDetailView(title: "Sender Name", description: "Md Wasim")
                TransactionSuccessPopupDetailView(title: "Amount", description: "10.00")
            }
            
            VStack {
                Text("Payment Status")
                    .font(AppFonts.bodyTwentyTwoBold)
                    .foregroundStyle(.appBlue)
                
                Image("success")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("SUCCESS")
                    .font(AppFonts.bodyTwentyTwoBold)
                    .foregroundStyle(.appBlue)
            }
            HStack(spacing: 20) {
                Button(action: captureSnapshotAndShare) {
                    Text("Share")
                        .font(AppFonts.bodySixteenBold)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.appBlue)
                        )
                }
                
                Button {
                    closure()
                } label: {
                    Text("Close")
                        .font(AppFonts.bodySixteenBold)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.appBlue)
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
        .sheet(isPresented: $isSharing) {
            if let image = snapshotImage {
                ActivityViewController(activityItems: [image]) // Sharing sheet
            }
        }
    }
    
    private func captureSnapshotAndShare() {
        hideButtonsAndCaptureSnapshot { capturedImage in
            snapshotImage = capturedImage
            isSharing = true // Show sharing sheet
        }
    }
    
    // Hide buttons and capture snapshot
    private func hideButtonsAndCaptureSnapshot(completion: @escaping (UIImage?) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootView = window.rootViewController?.view else {
            completion(nil)
            return
        }
        
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = rootView.frame
        hostingController.view.backgroundColor = .clear // Prevent black screen issue
        rootView.addSubview(hostingController.view)
        
        DispatchQueue.main.async {
            // Capture the snapshot
            let image = hostingController.view.asImage()

            hostingController.view.removeFromSuperview() // Cleanup
            completion(image)
        }
    }
}
struct TransactionSuccessPopupDetailView: View {
    var title: String
    var description: String

    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.regularEighteen)
                .foregroundStyle(.appBlue)
            Spacer()
            Text(description)
                .font(AppFonts.bodyEighteenBold)
                .foregroundStyle(.appBlue)
        }
    }
}

#Preview {
    TransactionSuccessPopupView(paidTo: "MOHAMED HASAN ALHARAZIcvzx") {}
}


struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
