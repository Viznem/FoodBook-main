/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Author: Pham Hoang Thien An, Nguyen Manh Khang, Nguyen Truong Thinh, Nguyen Dang Quang
  ID: s3818286, s3871126, s3777230, s3741190
  Created  date: 1/09/2022
  Last modified: 18/09/2022
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

struct HeartLikeView: View {
    @Binding var isLiked: Bool
    @State var startAnimate = false
    @State var bgAnimate = false
    @State var resetBgAnimate = false
    @State var fireworkAnimation = false
    @State var endAnimation = false
    @State var food: Food
    @ObservedObject var foodModel = FoodViewModel()
    
    //Like again during the animation
    @State var likeComplete = false
    
    //Settings many taps
    var taps: Int = 1
    
    var body: some View {
        Image(systemName: resetBgAnimate ? "suit.heart.fill" : "suit.heart")
            .font(.system(size: 30))
            .foregroundColor(resetBgAnimate ? .red : .gray)
            .scaleEffect(startAnimate && !resetBgAnimate ? 0 : 1)
            .opacity(startAnimate && !endAnimation ? 1 : 0)
            .background(
                ZStack {
                    CustomeShape(radius: resetBgAnimate ? 29 : 0)
                        .fill(Color.green)
                        .clipShape(Circle())
                    //Fixed
                        .frame(width: 50, height: 50)
                        .scaleEffect(bgAnimate ? 2.2 : 0)
                    
                    ZStack {
                        
                        let colors: [Color] = [.red,.yellow, .green, .blue, .pink, .orange]
                        
                        ForEach(1...6, id: \.self) {value in
                            Circle().fill(colors.randomElement()!)
                                .frame(width: 6, height: 6)
                                .offset(x: fireworkAnimation ? 60 : 30)
                                .rotationEffect(.init(degrees: Double(value) * 60))
                        }
                        
                        ForEach(1...6, id: \.self) {value in
                            Circle().fill(colors.randomElement()!)
                                .frame(width: 8, height: 8)
                                .offset(x: fireworkAnimation ? 44 : 14)
                                .rotationEffect(.init(degrees: Double(value) * 60))
                                .rotationEffect(.init(degrees: -45))
                        }
                    }.opacity(resetBgAnimate ? 1 : 0)
                        .opacity(endAnimation ? 0 : 1)
                    
                })
        
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture(count: taps){
                
                if likeComplete {
                    //reset the animation
                    updateBool(value: false)
                    foodModel.removeFromFavoriteCollection(food: food)
                    return
                }
                
                if startAnimate {
                    return
                }
                
                isLiked = true
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                    startAnimate = true
                }
                
                //chainAnimate
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                        bgAnimate = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                            resetBgAnimate = true
                        }
                        
                        //Fireworks animation
                        withAnimation(.spring()) {
                            fireworkAnimation = true
                            //save food document
                            foodModel.addToFavoriteCollection(food: food)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                endAnimation = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                likeComplete = true
                            }
                        }
                    }
                }
            }
            .onChange(of: isLiked) {newValue in
                if isLiked && !startAnimate {
                    //everything is set to true
                    updateBool(value: true)
                    //foodModel.addToFavoriteCollection(food: food)
                }
                if !isLiked {
                    updateBool(value: false)
                }
                
            }
    }
    func updateBool(value: Bool) {
        startAnimate = value
        bgAnimate = value
        resetBgAnimate = value
        fireworkAnimation = value
        endAnimation = value
        likeComplete = value
        isLiked = value
    }
}

//struct HeartLikeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeartLikeView(isLiked: .constant(false)))
//    }
//}


//Custom Shape
struct CustomeShape: Shape {
    
    var radius: CGFloat
    
    //set animation path
    var animatableData: CGFloat {
        get{return radius}
        set{radius = newValue}
    }
    
    
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x:0, y:0))
            path.addLine(to: CGPoint(x:0, y:rect.height))
            path.addLine(to: CGPoint(x:rect.width, y:rect.height))
            path.addLine(to: CGPoint(x:rect.width, y:0))
            
            //center circle
            let circleCenter = CGPoint(x:rect.width / 2, y:rect.height / 2)
            path.move(to: circleCenter)
            path.addArc(center: circleCenter, radius: radius, startAngle: .zero, endAngle: .init(degrees: 360), clockwise: false)
            
        }
    }
}

