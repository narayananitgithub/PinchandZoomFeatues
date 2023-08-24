//
//  ContentView.swift
//  PinchandZoomFeatues
//
//  Created by Narayanasamy on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: _ PROPERTY
//    @State private var imageState: String = ""
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffeset: CGSize = .zero
    @State private var  isDrawaerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    //MARK: - FUNCTION
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    //MARK: - BODY
    var body: some View {
//        VStack {
            
            NavigationView {
                ZStack {
                    Color.clear
                    // MARK: - PAGEIMGE
                    Image(currentPage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding()
                        .shadow(color: .black.opacity(0.2), radius: 12,x: 2,y: 2)
                        .opacity(isAnimating ? 1: 0)
                        .offset(x: imageOffeset.width ,y:imageOffeset.height )
                        .scaleEffect(imageScale)
                    // MARK: - 1. TAP GESTURE
                        .onTapGesture(perform:  {
                            if imageScale == 1 {
                                withAnimation(.spring()) {
                                    imageScale = 5
                                }
                            } else {
                                resetImageState()
                            }
                            
                        })
                    // MARK: - 2. DRAG GESTURE
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation(.linear(duration: 1)) {
                                        imageOffeset = value.translation
                                    }
                                }
                                .onEnded {_ in
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                        )
                    // MARK: - MAGNIFICATION
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    withAnimation(.linear(duration: 1)) {
                                        if imageScale >= 1 && imageScale <= 5 {
                                            imageScale = value
                                            
                                        } else if imageScale > 5 {
                                            imageScale = 5
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    if imageScale > 5 {
                                        imageScale = 5
                                    } else if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                        )
                    
                    
                }//ZSTACK
                .navigationTitle("Pinch & Zoom")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform:  {
                    withAnimation(.linear(duration: 1)) {
                        isAnimating = true
                    }
                })
                // MARK: - INFOPANEL
                .overlay(
                    InfoPanelView(scale: imageScale, offset: imageOffeset)
                        .padding(.horizontal)
                        .padding(.top,30)
                    ,alignment: .top
                        
                )
                // MARK: - CONTROLS
                .overlay(
                    Group {
                        HStack {
                           //SCALE DOWN
                            Button {
                                withAnimation(.spring()) {
                                    if imageScale > 1 {
                                        imageScale -= 1
                                        
                                        if imageScale <= 1 {
                                            resetImageState()
                                        }
                                    }
                                }
                                //Some action
                                
                            }label: {
                                ControlImageView(icon: "minus.magnifyingglass")
                                
                            }
                            
                           // RESET
                            HStack {
                                Button {
                                    //Some action
                                    resetImageState()
                                    
                                }label: {
                                    ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                                    
                                }
                            }
                          // SCALE UP
                            Button {
                                withAnimation(.spring()){
                                    if imageScale < 5 {
                                        imageScale += 1
                                        
                                        
                                        if imageScale > 5 {
                                            imageScale = 5
                                        }
                                    }
                                }
                                
                            }label: {
                                ControlImageView(icon: "plus.magnifyingglass")
                                
                            }
                            
                           
                        }//CONTROLS
                        .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .opacity(isAnimating ? 1: 0 )
                        
                    }
                        .padding(.bottom,30)
                    ,alignment: .bottom
                    
                )
                // MARK: - DRAWER
                .overlay(
                    HStack (spacing: 12) {
                        // MARK: - DRAWER HANDLE
                        Image(systemName:  isDrawaerOpen ? "chevron.compact.right": "chevron.compact.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(8)
                            .foregroundStyle(.secondary)
                            .onTapGesture( perform: {
                                withAnimation(.easeOut){
                                    isDrawaerOpen.toggle()
                                }
                            })
                        
                        // MARK: - THUMBNAILS
                        
                        ForEach(pages) { item in
                            Image(item.thumbnailName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                                .opacity(isDrawaerOpen ? 1: 0)
                                .animation(.easeOut(duration: 0.5),value: isDrawaerOpen)
                                .onTapGesture ( perform : {
                                    isAnimating = true
                                    pageIndex = item.id
                                    
                                    
                                })
                        }
                        
                        Spacer()
                    }// DRAWER
                        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .opacity(isAnimating ? 1: 0)
                        .frame(width: 260)
                        .padding(.top,UIScreen.main.bounds.height / 12)
                        .offset(x: isDrawaerOpen ? 20 : 215)
                    , alignment: .topTrailing
                )
                
                    
                }//NAVIGATION
//            }
            
            .navigationViewStyle(.stack)
        }
            
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
