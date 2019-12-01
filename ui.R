library(shiny)

shinyUI(
    fluidPage(
        
        # App title ----
        titlePanel("Eigenfaces in Shiny"),
        # tags$style(type="text/css",
        #            ".shiny-output-error { visibility: hidden; }",
        #            ".shiny-output-error:before { visibility: hidden; }"
        # ),
        #
        # Sidebar layout with input and output definitions ----
        
        sidebarLayout(
            
            # Sidebar panel for inputs ----
            sidebarPanel(
                
                # Input: Select a file ----
                fileInput("test", "Choose Test Image to be classified", multiple = FALSE),
                
                # Horizontal line ----
                tags$hr(),
                
                #Go button
                actionButton("goButton", "Go!"),
                
                # Horizontal line ----
                tags$hr(),
                #Go button
                p("This app was created on november 2019."),
                p("Code is available on: github.com/simonsanvil/shinyEigenfaces")
            ),
            mainPanel(
                
                # Output: wordcloud ----
                plotOutput("plot",width = "300px", height="300px")
            )
       
            
        )
    )
)
