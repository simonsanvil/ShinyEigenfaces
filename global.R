require(bmp)
require(grid)

#CLASSIFICATION USING PCA + SVM
classify_PCA_SVM <- function(test,#The test matrix is the only things that needs to be provided by the user
                             Eigenfaces,w.train,labels.train, train_scaled.attr, 
                             svm_classifier){
    
    test.scaled = scale(test,
                        center = train_scaled.attr$center,
                        scale = train_scaled.attr$scale)
    
    #Project the test set on the Eigenspace of n principal components
    w.test = t(t(Eigenfaces)%*%t(test.scaled))
    to.predict = as.data.frame(w.test)
    
    #Classify using the svm model
    classification = as.character(predict(svm_classifier, newdata = to.predict))
    
    return(classification)
}

parseBMP <- function(image){
    Im = read.bmp(image$datapath)
    red = as.vector(Im[,,1]) #each vector is of size 120*165 px = 19800
    green = as.vector(Im[,,2])
    blue = as.vector(Im[,,3])
    test.m = t(c(red, green, blue))
    return(test.m)
}

