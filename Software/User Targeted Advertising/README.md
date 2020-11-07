# User Targeted Advertising

[**Click here to visit our website**](https://cepdnaclk.github.io/e16-3yp-digital-signage-based-user-targeted-advertising/)



##  Introduction

User Targeted Advertising folder mainly contains two jupyter notebook files. 
Both of these codes use the trained data models (age_net.caffemodel and gender_net.caffemodel) and opencv libraries to predict gender and age.
Caffe framework is used to train the data sets.
   
 - Age and Gender detection for Images.ipynb
    \
    Prediction is done for images saved in a folder.
    
 - Age and Gender Detection11.ipynb
   \
  Prediction is done by capturing the video using the webcam. This is the real scenario happening in our project.
  
  
 
## How To Run The Application.

We can run the two jupytor files in the same way.

To run the above two applications, you don't need to have all the files uploaded in this folder. Because it contains all the datasets and codes to train the datasets. You should have below files to run the code.
 - jupytor notebook file
 - gender_net.caffemodel
 - age_net.caffemodel
 - haarcascade folder
 - deploy_age.prototxt
 - deploy_gender.prototxt
 
You have to do below changes in the jupitor file before running it. These changes are suitable for both jupytor files.

 - <b>Give correct path for the caffe models and prototxt files changing below 4 lines of code</b>
   
   <pre>protoPathage = os.path.sep.join([r"path to the folder where deploy_age.prototxt is in",  "deploy_age.prototxt"])
   
   modelPathage = os.path.sep.join([r"path to the folder where age_net.caffemodel is in","age_net.caffemodel"])

   protoPathgender = os.path.sep.join([r"path to the folder where deploy_gender.prototxt  is in",  "deploy_gender.prototxt"])
   
   modelPathgender = os.path.sep.join([r"path to the folder where gender net.caffemodel is in","gender_net.caffemodel"])
   </pre>


 - <b>To load the pre-built model for facial detection, edit below line of code.</b>
 
   <pre>face_cascade_path = os.path.sep.join([r"path to haarcascade code",  "haarcascade_frontalface_default.xml"])</pre>
   
 - <b>If you are running Age and Gender detection for Images.ipynb edit below line of code to add the path to the sample image. </b>
  
   <pre>image = cv2.imread(r"Path to sample image")<pre>
   
  By doing these changes you can successfully run the application. Make sure you have installed anaconda navigator , opencv and numpy libraries.
   




