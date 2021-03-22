FROM ubuntu:18.04
## Update the console. Do note that the installation is based on Python 3.6 version. 
#If you want to use a different version, do remember to properly change the version appropriately and consider
#changing the Opencv module

RUN apt-get update && apt-get install python3.6 python3-pip unixodbc-dev python3-venv libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libcurl4 libxcomposite1 libasound2 libxi6 libxtst6 curl -y

## Install the apps
RUN python3 -m pip install -U pip
RUN python3 -m pip install -U setuptools
RUN python3 -m pip install tensorflow
RUN python3 -m pip install boto3
RUN python3 -m pip install prefect
RUN python3 -m pip install jupyterlab
RUN python3 -m pip install plotly==4.14.3
RUN python3 -m pip install pandas
RUN python3 -m pip install numpy
RUN python3 -m pip install scipy
RUN apt-get install sudo wget -y
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
RUN sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN wget https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
RUN sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
RUN sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
RUN sudo apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install lightdm -y
RUN sudo apt-get -y install cuda
RUN python3 -m pip install torch torchvision torchaudio
RUN python3 -m pip install plotly==4.14.3
#Install opencv
RUN sudo apt-get update -y
RUN sudo apt-get upgrade -y
#Install developer tools
RUN sudo apt-get install build-essential cmake unzip pkg-config -y
RUN sudo apt-get install libjpeg-dev libpng-dev libtiff-dev -y
RUN sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y
RUN sudo apt-get install libxvidcore-dev libx264-dev -y
#RUN install GTK for GUI
RUN sudo apt-get install libgtk-3-dev -y
#RUN install packages for Mathematical Optimizations for OpenCV
RUN sudo apt-get install libatlas-base-dev gfortran -y
#RUN install Python3 deelopment headers
RUN sudo apt-get install python3-dev -y
#RUN install OpenCV with the additional contrib modules
#RUN Download
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.0.zip
#RUN Unzip
RUN unzip opencv.zip
RUN unzip opencv_contrib.zip
#Rename directories 
RUN mv opencv-4.0.0 opencv
RUN mv opencv_contrib-4.0.0 opencv_contrib
#Create a build directory
RUN cd /opencv
RUN mkdir /opencv/build/
#Write installation commands to a file in the default directory
RUN echo 'cd /opencv/build/' > cmake_run.sh
RUN echo 'cmake -D CMAKE_BUILD_TYPE=RELEASE \' >> cmake_run.sh
RUN echo '      -D CMAKE_INSTALL_PREFIX=/usr/local \' >> cmake_run.sh
RUN echo '      -D INSTALL_PYTHON_EXAMPLES=ON \' >> cmake_run.sh
RUN echo '      -D INSTALL_C_EXAMPLES=OFF \' >> cmake_run.sh
RUN echo '      -D OPENCV_ENABLE_NONFREE=ON \' >> cmake_run.sh
RUN echo '      -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \' >> cmake_run.sh
RUN echo '      -D PYTHON_EXECUTABLE=/usr/bin/python3.6 \' >> cmake_run.sh
RUN echo '      -D BUILD_EXAMPLES=ON ..' >> cmake_run.sh
RUN echo 'make -j4' >> cmake_run.sh
RUN echo 'sudo make install' >> cmake_run.sh
RUN echo 'sudo ldconfig' >> cmake_run.sh
#Move the file to the location for installation and run the file
RUN mv cmake_run.sh /opencv/build/
RUN chmod +x /opencv/build/cmake_run.sh
RUN /opencv/build/cmake_run.sh
RUN mv /usr/local/python/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so /usr/local/python/cv2/python-3.6/cv2.so
RUN python3 import cv2

