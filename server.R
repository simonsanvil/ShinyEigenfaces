library(shiny)
library(bmp)
library(ggplot2)
require(OpenImageR)


shinyServer(function(input, output, session) {
    # Define a reactive expression for the document term matrix
    
    data <- reactive({
        validate(
            need(input$test != '', "Please introduce a file")
        )
    })
    
    
    
    getImageData <- reactive({
        # Change when the "update" button is pressed...
        
        input$goButton
        
        # ...but not for anything else
        isolate({
            withProgress({
                setProgress(message = "Processing model...")
                parseBMP(input$test)
            })
        })
    })
    
    observe({
        output$plot <- renderPlot({
            data()
            test.m = getImageData()
            this_dir <- dirname(rstudioapi::getSourceEditorContext()$path); #Only works with Rstudio
            setwd(this_dir)
            load('Rdata/indices_train.Rdata') #is a vector with 480 labels (1-80) identifying each picture in the given train set.  
            load("Rdata/scaled_train_attr.Rdata") #The center and variance of the original train set to scale the test based on it. 
            load("Rdata/Eigenfaces.Rdata") #The eigenfaces matrix of size 156x59400
            load("Rdata/w_train.Rdata") #Projection of the train test onto the eigenspace of n principal component
            load("Rdata/svm_classiffier.Rdata") #The SVM classifier
            classification = classify_PCA_SVM(test.m,
                                              Eigenfaces,w.train,train.indices,train.scaled.attr,
                                              classifier.svm)
            if(classification != 0){
                classification = paste('Classified as person with label',as.character(classification))
            }else{
                classification = paste('Classified as person with label',as.character(classification),' (Impostor)')
            }
            img = array(test.m, c(165,120,3))
            g <- rasterGrob(as.raster(img,max = 255), interpolate=TRUE)
            qplot(1:10, 1:10, geom="blank") +
                annotation_custom(g, xmin=-Inf, xmax=Inf, ymin=1.5, ymax=Inf) + 
                theme_minimal() +
                theme(line = element_blank(),
                      text = element_blank(),
                      title = element_blank()) + 
                annotate('text',x = 5.5,y = 1, size = 3.5,
                         label = classification)

        }) 
    })
})