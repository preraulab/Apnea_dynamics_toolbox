# Apnea_dynamics_toolbox
The sleep apnea dynamics toolbox implemented in Matlab
### This is the repository for the code referenced in: 
> Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau*, [Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing and a Statistical Framework for Phenotype Exploration], SLEEP 2022 (in press)
--- 

## Table of Contents
* [General Information](#general-information)
* [Data Format Description](#data-format-description)
* [Building Design Matrix](#building-design-matrix)
* [Model Fitting](#model-fitting)
* [Model Visualization](#model-visualization)
* [Citations](#citations)
* [Status](#status)
* [References](#references)

## General Information
The code in this repository is companion to the paper:
> Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau*, [Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing and a Statistical Framework for Phenotype Exploration], SLEEP 2022 (in press)

Obstructive sleep apnea (OSA), in which breathing is reduced or ceased during sleep, affects at least 10% of the population and is associated with numerous comorbidities. Current clinical diagnostic approaches characterize severity and treatment eligibility using the average respiratory event rate over total sleep time (apnea hypopnea index, or AHI). This approach, however, does not characterize the time-varying and dynamic properties of respiratory events that can change as a function of body position, sleep stage, and previous respiratory event activity. Here, we develop a statistical model framework based on point process theory that characterizes the relative influences of all these factors on the moment-to-moment rate of event occurrence.

This model acts as a highly individualized respiratory fingerprint, which we show can accurately predict the precise timing of future events. We also demonstrate robust model differences in age, sex, and race across a large population. Overall, this approach provides a substantial advancement in OSA characterization for individuals and populations, with the potential for improved patient phenotyping and outcome prediction.

Herein, we provide code to walk through people, from constructing model input to model fitting, as well as the code to visualize the model.

<!--- UPDATE THIS USING GRAPHICAL ABSTRACT<br/>
<p align="center"> 
<img src="https://prerau.bwh.harvard.edu/spindle_view/TFpeaks_gitImage_info.png" alt="spind" width="600" height="300" />| 
</p>

<p align="center"> 
<sup><sub>Spindles are a subset of TFσ peaks. Traditionally scored spindles (magenta regions) are represented as sigma range (10-16Hz) time-frequency peaks in the spectrogram (TFσ peaks) (boxed regions). While scored spindles correspond directly to TFσ peaks, there are many clear TFσ peaks that are not scored as spindles. Source: Dimitrov et. al <sup>10</sup></sup></sub> 
</p>

<br/> --->
<br/>



