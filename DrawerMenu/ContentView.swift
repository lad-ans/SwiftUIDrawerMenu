//
//  ContentView.swift
//  DrawerMenu
//
//  Created by ladans on 03/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isDrawerOpen: Bool = false
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let drawerWidth = proxy.size.width * 0.8
            
            ZStack {
                NavigationStack {
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Drawer Menu")
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Image(systemName: "line.3.horizontal")
                                .onTapGesture {
                                    drawerToggler(drawerWidth)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background {
                        Color.gray.opacity(isDrawerOpen ? 0.3 : 0.0).ignoresSafeArea()
                            .onTapGesture {
                                drawerToggler(drawerWidth)
                            }
                    }
                }
                
                Rectangle()
                    .fill(Color.indigo.gradient)
                    .overlay {
                        Text("Drawer Menu")
                            .foregroundStyle(.white)
                            .font(.title)
                        
                        Button("", systemImage: "xmark") {
                            drawerToggler(drawerWidth)
                        }
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .frame(width: 25, height: 25)
                        .offset(x: (drawerWidth * 0.5) - 35, y: -proxy.frame(in: .local).midY - 20 + proxy.safeAreaInsets.top)
                    }
                    .frame(width: drawerWidth)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 3)
                    .offset(x: offset - drawerWidth)
                    .edgesIgnoringSafeArea(.all)
            }
            .gesture(
                DragGesture()
                    .updating($gestureOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onChanged { value in
                        let offsetX = value.translation.width
                        
                        if offsetX > drawerWidth ||
                            (offsetX > 0 && isDrawerOpen) ||
                            (offsetX < 0 && !isDrawerOpen) {
                            return
                        }
                        
                        withAnimation(.easeOut(duration: 0.2)) {
                            if !isDrawerOpen {
                                offset = offsetX
                            } else {
                                offset = lastOffset + offsetX
                            }
                        }
                    }
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let threshold: CGFloat = drawerWidth / 2
                        
                        withAnimation(.easeOut(duration: 0.25)) {
                            if offsetX > threshold || (offsetX < 0 && offsetX > -threshold) {
                                offset = drawerWidth
                                isDrawerOpen = true
                            } else {
                                offset = 0
                                isDrawerOpen = false
                            }
                        }
                        lastOffset = offset
                    }
            )
        }
    }
    
    func drawerToggler(_ value: CGFloat) {
        withAnimation(.easeOut(duration: 0.2)) {
            isDrawerOpen.toggle()
            
            if isDrawerOpen {
                offset = value
            } else {
                offset = 0
            }
            lastOffset = offset
        }
    }
    
}

#Preview {
    ContentView()
}
