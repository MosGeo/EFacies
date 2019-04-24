# EFacies: Multiscale electrofacies analysis on borhole data

A workflow for stochastic electrofacies classification from borehold depth data. The code is modularized so that different components can be replaced and modified easily.

<div align="center">
    <img width=1000 src="https://github.com/MosGeo/Efacies/blob/master/ReadmeFiles/Main.png" alt="Graph" title="Graph example"</img>
</div>

# How does it work?

The procedure used here involves a number of steps. Different settings can modify the workflow at each step.
1. Preprocessing including normalization
2. Principle component analysis to decorrelate the data
3. Self organizing maps for initial classification
4. Hierarchical clustering to obtain the multiscale classification

# How to run?

Check the main.m file for an example on how to use the code.

# Reference
Al Ibrahim, M. A., and Mukerji, T., 2015, Stochastic Multiscale Electrofacies Classification of Well Logs: A Case Study From North Slope, Alaska: Presented at the AAPG Annual Convention and Exhibition, Calgary, Alberta, Canada.

