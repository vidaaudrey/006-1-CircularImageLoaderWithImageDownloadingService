# 006-1 Circular Image Loader Indicator with Image Downloading Service 

![Snapshot 1](https://github.com/vidaaudrey/006-Circular-Image-Loader-Indicator/blob/master/_Snapshot/Snapshot.gif)


**Description**: A circular image downloading process indicator. 

**Use**: Create an UIImageView in storyboard and specify the class to be “LeanCustomImageView". Further customize the URL link from "LeanCustomImageView.swift"

**Note**: "ImageDownloadService" class is created to separate the downloading function from the definition of the "LeanCustomImageView". It has a weak reference to the "LeanCustomImageView". 

[*Reference*](http://www.raywenderlich.com/94302/implement-circular-image-loader-animation-cashapelayer)
