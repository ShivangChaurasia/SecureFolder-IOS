import SwiftUI

struct FileThumbnailView: View {
    let file: StoredFile
    let fileURL: URL
    
    var body: some View {
        VStack {
            if isImage() {
                if let uiImage = UIImage(contentsOfFile: fileURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    fallbackIcon()
                }
            } else {
                fallbackIcon()
            }
            
            Text(file.fileName)
                .font(.caption)
                .lineLimit(1)
                .frame(maxWidth: 100)
        }
    }
    
    private func isImage() -> Bool {
        let imgExts = ["jpeg", "jpg", "png"]
        return imgExts.contains(file.fileExtension.lowercased())
    }
    
    @ViewBuilder
    private func fallbackIcon() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.secondarySystemBackground))
                .frame(width: 80, height: 80)
            
            Image(systemName: isImage() ? "photo" : "doc.text.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
        }
    }
}
