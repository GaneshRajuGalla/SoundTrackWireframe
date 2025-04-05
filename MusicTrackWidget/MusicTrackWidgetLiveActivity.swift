//
//  MusicTrackWidgetLiveActivity.swift
//  MusicTrackWidget
//
//  Created by Ajay Rajput on 23/08/23.
//

import ActivityKit
import WidgetKit
import SwiftUI


@main
struct MusicWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MusicTrackWidget()
    }
}

//@main
struct MusicTrackWidget: Widget {
    let kind: String = "MusicTrackWidget"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MusicAttributes.self) { context in
            
            MusicTrackWidgetEntryView(attribute: context.attributes, state: context.state)

        } dynamicIsland: { context in
            DynamicIsland {
                // This content will be shown when the user expands the island
                
                DynamicIslandExpandedRegion(.center) {
                    VStack {
//                        Text("Driver in front is \(context.state.isPlaying) 🏎")
                        Text(" ")
//                        MusicTrackWidgetEntryView(attribute: context.attributes, state: context.state)
                    }
                }
                
            } compactLeading: {
                // This view is shown on the left side of the Dynamic Island
                Text(" ")
            } compactTrailing: {
                // This view is shown on the right side of the Dynamic Island
                Image(systemName: "play")
            } minimal: {
                // This view will be shown when there are multiple activities running at ones
                Text(" ")
            }
        }

    }
}

struct MusicTrackWidgetEntryView : View {

    @State var attribute: MusicAttributes
    @State var state: MusicAttributes.ContentState

    var body: some View {
        LiveMusicView(attribute: attribute, state: state)
            .activitySystemActionForegroundColor(Color(uiColor: UIColor.appDarkText))
//            .activityBackgroundTint(Color(uiColor: UIColor.appDarkText))
    }
    
    var MusicView: some View {
        
        VStack {
            ZStack{

                HStack(spacing: 30){
                    Text(attribute.category)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(state.timeRemaining!)
                        .font(.headline)
                        .foregroundColor(.white)

                    Button {

                    } label: {
                        ZStack{
                            LinearGradient(colors: [.white,.gray], startPoint: .top, endPoint: .bottom)
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                            Image("pause")
                                .tint(.black)
                        }
                    }

                    Button {

                    } label: {
                        Image("Next")
                            .tint(Color.white)
                    }

                }
//                .frame(height: 40)
            }
            .padding(.top)
            
            
            VStack{
                Text(attribute.appName)
                    .font(.headline)
                    .foregroundColor(.white)
                    
            }
            .frame(height: 40)
            
                
        }
    }
    
    
}

struct WidgetExtension_Previews: PreviewProvider {
  static var previews: some View {
    let testAttribute = MusicAttributes(appName: "Soundtrack", totalMinutes: 2, category: "Demo")
    let testState = MusicAttributes.ContentState(isPlaying: false)
    
      MusicTrackWidgetEntryView(attribute: testAttribute, state: testState)
      .previewContext(
        WidgetPreviewContext(
          family: .systemLarge
        )
      )
  }
}
