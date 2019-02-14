#include <cstdio>
#include <opencv2/opencv.hpp>
#include "ni_test.hpp"
/*
#include <opencv2/videoio.hpp>
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/videoio.hpp"
#include <iostream>
#include <stdio.h>
//*/

using namespace std;
using namespace cv;

int main(int argc, char **argv)
{
	bool kinect = true;
	if (kinect)
	{
		return run_kinect();
	}
	else //webcam
	{
		run_webcam();
	}
}

int run_kinect()
{
	Mat depthMat(Size(640,480),CV_16UC1);
	Mat depthf (Size(640,480),CV_8UC1);
	Mat rgbMat(Size(640,480),CV_8UC3,Scalar(0));
	
	Freenect::Freenect freenect;
	MyFreenectDevice& device = freenect.createDevice<MyFreenectDevice>(0);
	
	namedWindow("rgb",CV_WINDOW_AUTOSIZE);
	namedWindow("depth",CV_WINDOW_AUTOSIZE);
	device.startVideo();
	device.startDepth();
	while (true)
	{
		device.getVideo(rgbMat);
		device.getDepth(depthMat);
		imshow("rgb", rgbMat);
		depthMat.convertTo(depthf, CV_8UC1, 255.0/2048.0);
		imshow("depth",depthf);
		char k = cvWaitKey(5);
	}
	device.stopVideo();
	device.stopDepth();
	return 0;
	
}

int run_webcam()
{
	cout << getBuildInformation() << endl;
	VideoCapture capture(0);//webcam number
	Mat bgrImage;
	while(true)
	{
		capture.grab();
		capture.retrieve(bgrImage, CV_CAP_OPENNI_BGR_IMAGE);
		imshow("Color", bgrImage);
		if(waitKey(5) >= 0) break;
	}
	return 0;
}

/*
//Gives black screen for video, but depth might work.
Kinect::Kinect()
{
	// maybe pass in these Mat's in the constructor?
	depthMat = new Mat(Size(640,480),CV_16UC1);
	depthf = new Mat(Size(640,480),CV_8UC1);
	rgbMat = new Mat(Size(640,480),CV_8UC3,Scalar(0));
	ownMat = new Mat(Size(640,480),CV_8UC3,Scalar(0));
	
	device.startVideo();
	device.startDepth();
	
	
}
bool Kinect::getDepth(Mat& output)
{
	return device.getDepth(output);
}
bool Kinect::getVideo(Mat& output)
{
	return device.getDepth(output);
}
Kinect::~Kinect()
{
	device.stopVideo();
	device.stopDepth();
	
	delete depthMat;
	delete depthf;
	delete rgbMat;
	delete ownMat;
}
//*/
