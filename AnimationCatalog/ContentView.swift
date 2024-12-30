import SwiftUI

struct AnimationCatalog: View {
    let animations: [(String, AnyView)] = [
        ("Basic: State Change", AnyView(BasicStateAnimation())),
        ("Transition: Combined (Slide + Opacity)", AnyView(CombinedTransition())),
        ("Spring: Custom Spring", AnyView(CustomSpringAnimation())),
        ("Timing Curve: EaseInOut", AnyView(TimingCurveAnimation())),
        ("Modifier: Rotation and Scale", AnyView(ModifierAnimation())),
        ("Repeat and Delay", AnyView(RepeatDelayAnimation())),
        ("Chained Animation", AnyView(ChainedAnimation())),
        ("3D Animation", AnyView(Rotation3DAnimation())),
        ("MatchedGeometryEffect", AnyView(MatchedGeometryEffectExample())),
        ("Animate Progress", AnyView(ProgressBarExample())),
        ("ParallaxEffect", AnyView(ParallaxEffectExample()))
    ]
    
    var body: some View {
        NavigationStack {
            List(animations, id: \.0) { animation in
                NavigationLink(destination: animation.1) {
                    Text(animation.0)
                }
            }
            .navigationTitle("Improved Animation Catalog")
        }
    }
}

// 各アニメーション例の実装

// 1. 基本アニメーション
struct BasicStateAnimation: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            Circle()
                .fill(isActive ? Color.blue : Color.red)
                .frame(width: isActive ? 100 : 50, height: isActive ? 100 : 50)
                .animation(.easeInOut, value: isActive)
            
            Button("Toggle State") {
                isActive.toggle()
            }
        }
        .padding()
    }
}

// 2. 複合トランジション
struct CombinedTransition: View {
    @State private var isVisible = false

    var body: some View {
        VStack {
            if isVisible {
                Text("Hello, World!")
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .transition(.slide.combined(with: .opacity))
            }
            
            Button("Toggle") {
                withAnimation {
                    isVisible.toggle()
                }
            }
        }
        .padding()
    }
}

// 3. スプリングアニメーション
struct CustomSpringAnimation: View {
    @State private var position: CGFloat = 0

    var body: some View {
        VStack {
            Circle()
                .fill(Color.purple)
                .frame(width: 50, height: 50)
                .offset(y: position)
                .animation(.interpolatingSpring(stiffness: 50, damping: 5), value: position)
            
            Button("Animate") {
                position = position == 0 ? 200 : 0
            }
        }
        .padding()
    }
}

// 4. タイミングカーブ
struct TimingCurveAnimation: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.orange)
                .frame(width: 100, height: 50)
                .offset(x: offset)
                .animation(.timingCurve(0.25, 0.1, 0.25, 1, duration: 2), value: offset)
            
            Button("Animate") {
                offset = offset == 0 ? 200 : 0
            }
        }
        .padding()
    }
}

// 5. モディファイアアニメーション
struct ModifierAnimation: View {
    @State private var angle: Double = 0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .rotationEffect(.degrees(angle))
                .animation(.easeInOut, value: angle)
                .animation(.easeInOut, value: scale)
            
            Button("Rotate and Scale") {
                angle += 45
                scale = scale == 1.0 ? 1.5 : 1.0
            }
        }
        .padding()
    }
}

// 6. 繰り返しと遅延
struct RepeatDelayAnimation: View {
    @State private var rotation: Double = 0

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: 100, height: 50)
                .rotationEffect(.degrees(rotation))
                .animation(
                    .easeInOut(duration: 1).repeatForever(autoreverses: true).delay(0.5),
                    value: rotation
                )
            
            Button("Start Animation") {
                rotation += 360
            }
        }
        .padding()
    }
}

// 7. 非同期アニメーションチェーン
struct ChainedAnimation: View {
    @State private var scale = 1.0
    @State private var color = Color.red

    var body: some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 100 * scale, height: 100 * scale)
            
            Button("Animate Chain") {
                withAnimation(.easeInOut(duration: 1)) {
                    scale = 1.5
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1)) {
                        scale = 1.0
                        color = .blue
                    }
                }
            }
        }
        .padding()
    }
}

// 8. 3Dアニメーション
struct Rotation3DAnimation: View {
    @State private var angle: Double = 0

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.pink)
                .frame(width: 100, height: 100)
                .rotation3DEffect(.degrees(angle), axis: (x: 1, y: 1, z: 0))
                .animation(.easeInOut, value: angle)
            
            Button("Rotate 3D") {
                angle += 45
            }
        }
        .padding()
    }
}


struct MatchedGeometryEffectExample: View {
    @Namespace private var animationNamespace
    @State private var isExpanded = false

    var body: some View {
        VStack {
            HStack {
                // 小さい状態のRectangle
                Rectangle()
                    .matchedGeometryEffect(id: "rect", in: animationNamespace)
                    .frame(width: isExpanded ? 300 : 100, height: isExpanded ? 300 : 100)
                    .foregroundColor(isExpanded ? .blue : .red)
                    .cornerRadius(20)
            }

            Button("Toggle Size") {
                withAnimation {
                    isExpanded.toggle()
                }
            }
        }
        .padding()
    }
}

struct ProgressBarExample: View {
    @State private var progress: CGFloat = 0.0

    var body: some View {
        VStack {
            ZStack {
                // 背景の円
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    .frame(width: 220, height: 220)
                
                // 進捗バー
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(Color.blue, lineWidth: 20)
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(-90)) // 開始点を上に設定
                    .animation(.linear(duration: 3), value: progress) // アニメーション設定
            }
            
            Button("Animate Progress") {
                withAnimation {
                    progress = 1.0 // 100%進捗にアニメーション
                }
            }
            .padding(.top, 20)
        }
        .padding()
    }
}

struct ParallaxEffectExample: View {
    @State private var dragAmount: CGSize = .zero

    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .offset(dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragAmount = value.translation
                        }
                        .onEnded { _ in
                            withAnimation(.easeOut) {
                                dragAmount = .zero
                            }
                        }
                )

            Text("Drag me!")
        }
        .padding()
    }
}


// プレビュー
#Preview {
    AnimationCatalog()
}
