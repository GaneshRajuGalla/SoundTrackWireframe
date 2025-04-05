//
//  LiveMusicView.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 23/08/23.
//

import SwiftUI
import WidgetKit

struct LiveMusicView: View {
    
    @State var attribute: MusicAttributes
    @State var state: MusicAttributes.ContentState
    @State private var progress = 0.1
    
    var body: some View {
        
        VStack {
            ZStack{
                Color.white
                HStack(spacing: 20){
                    Text(attribute.appName)
                        .font(.manrope(.regular,size: 18))
                        .foregroundColor(.black)
                    Spacer()
                    if attribute.totalMinutes == 0{
                        Image("infinity")
                            .tint(Color.black)
                    }else{
                        Text("\(attribute.totalMinutes/60) mins")
                            .frame(alignment: .leading)
                            .foregroundColor(.black)
                    }
                }
                .padding([.leading,.trailing])
            }
            .frame(height: 50)
            
            
            ZStack{

                HStack{
                    Image(attribute.appLogo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40,height: 40)
                        .cornerRadius(4)
                    Spacer()
                    Text(attribute.category)
                        .font(.manrope(.semibold,size: 18))
                        .foregroundColor(.white)

                    Spacer()
                    Button {
                        print("Play/Pause Tapped")
                    } label: {
                        ZStack{
                            LinearGradient(colors: [.white,.gray], startPoint: .top, endPoint: .bottom)
                                .cornerRadius(20)
                            Image(systemName: state.isPlaying ? "pause.fill" : "play.fill")
                                .tint(.black)
                                .frame(width: 20, height: 20)

                        }
                    }
                    .frame(width: 40, height: 40)
                    Spacer()
                    Button {
                        print("Next Tapped")
                    } label: {
                        Image("Next")
                            .tint(Color.white)
                    }

                }
                .padding([.leading,.trailing])
                .frame(height: 40)
            }
            .padding(.top,10)
            
            ProgressView(value: Double(state.currentTime ?? 0),total: Double(attribute.totalMinutes))
                        .padding()
        }
//        .background(Color(uiColor: .appDarkText))
    }
}

struct LiveMusicView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMusicView(attribute: MusicAttributes(appName: "Soundtrack", totalMinutes: 0, category: "sds"), state: .init(isPlaying: true))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
