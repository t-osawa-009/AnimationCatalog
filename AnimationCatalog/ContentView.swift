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
        ("3D Animation", AnyView(Rotation3DAnimation()))
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
            Circle()
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

// プレビュー
#Preview {
    AnimationCatalog()
}
