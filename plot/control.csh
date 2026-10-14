#!/bin/csh

ncl < plot_Fig.3ab.ncl
ncl < plot_Fig.4b.ncl
ncl < plot_Fig.5.ncl
ncl < plot_Fig.6b.ncl
ncl < plot_Fig.S2.ncl
ncl < plot_Fig.S3.ncl

python < plot_Fig.3c.py
python < plot_Fig.4a.py	
python < plot_Fig.6a.py	
python < plot_Fig.7.py
