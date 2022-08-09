# Apnea_dynamics_toolbox
The sleep apnea dynamics toolbox implemented in Matlab
### This is the repository for the code referenced in: 
> Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau*. Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing and a Statistical Framework for Phenotype Exploration, Sleep, 2022, zsac189, https://doi.org/10.1093/sleep/zsac189
--- 

## Table of Contents
* [General Information](#general-information)
* [Data Format Description](#data-format-description)
* [Building Design Matrix](#building-design-matrix)
* [Model Fitting](#model-fitting)
* [Model Visualization](#model-visualization)
* [Example Data](#example-data)
* [Citations](#citations)
* [Status](#status)


<br/>
<br/>

## General Information
The code in this repository is companion to the paper:
> Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau*. Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing and a Statistical Framework for Phenotype Exploration, Sleep, 2022, zsac189, https://doi.org/10.1093/sleep/zsac189

Obstructive sleep apnea (OSA), in which breathing is reduced or ceased during sleep, affects at least 10% of the population and is associated with numerous comorbidities. Current clinical diagnostic approaches characterize severity and treatment eligibility using the average respiratory event rate over total sleep time (apnea hypopnea index, or AHI). This approach, however, does not characterize the time-varying and dynamic properties of respiratory events that can change as a function of body position, sleep stage, and previous respiratory event activity. Here, we develop a statistical model framework based on point process theory that characterizes the relative influences of all these factors on the moment-to-moment rate of event occurrence.

This model acts as a highly individualized respiratory fingerprint, which we show can accurately predict the precise timing of future events. We also demonstrate robust model differences in age, sex, and race across a large population. Overall, this approach provides a substantial advancement in OSA characterization for individuals and populations, with the potential for improved patient phenotyping and outcome prediction.

Herein, we provide code to walk through people, from constructing model input to model fitting, as well as the code to visualize the model.

<!---
<br/>
<p align="center">

<img src="https://github.com/preraulab/Apnea_dynamics_toolbox/blob/master/graph_abs.jpg" width="1000" />
</p> --->

<sup><sub>**Graphical Abstract:** Moving from the constant AHI, a statistical framework models the “instantaneous AHI” as a function of body position, sleep stage and past event activity. From top to bottom, the graphical abstract shows the respiratory event train across the entire night for a single subject, followed by the body position and hypnogram. The AHI for this participant is around 17 (events/hr), a static metric that poorly describes the whole night event pattern. To recover the dynamics lost by AHI, the PSH model uses information from position, stage and the history dependence structure to provide much stronger predictions for individual events. Source: Chen et al, Sleep 2022 </sup></sub>


<br/>
<br/>



## Data Format Description
To analyze apnea dynamics, we need these required information
* apnea event time: the apnea event end times 
* sleep stage: stage times and corresponding stages
  - 1: N3 stage
  - 2: N2 stage
  - 3: N1 stage
  - 4: REM (Rapid Eye Movement sleep)
  - 5: Wake
* body position: position times and corresponding positions. Raw positions (0:Right; 1: Back; 2: Left; 3: Prone; 4: Upright) are relabeled as:
  - 1: Supine (Sleep on back)
  - 0: Non-Supine (Right, Left, Prone, Upright)

<!--- Usage:
```
hand_scoring_tfpeaks(data, Fs, staging)
``` --->


<br/>
<br/>

## Building Design Matrix

To prepare for the model fitting, we need to convert the data into a design matrix that contains all the predictors and a corresponding response column that indicates the apnea event occurrence. Apnea event times were discretized into 1-second intervals and the time series the number of respiratory events (0 or 1) terminating in each of those intervals was computed.


* Response (y): [n x 1] vector, binary (0 or 1) event train, 1 means the apnea event happened at that time interval
* Design matrix: [n x 15] matrix defined as [pos sta history] 
  - Body position (pos): [n x 1] vector, binary (0 or 1), 1 means Supine position at that time interval
  - Sleep stage (sta): [n x 5] matrix defined as [N1 N2 N3 REM Wake], binary (0 or 1), value 1 in each stage column indicates the corresponding stage the participant is in at that time interval    
  - Event history (history):[n x 9] matrix describes the past event activity in the cardinal spline basis
    - Total time lag: 150
    - Tension parameter s: 0.5
    - Number of knots: 9
    - Knot location setting: With end points at 0 and 150 seconds, 4 knots were placed evenly between the 10th percentile of inter-event intervals and 90 seconds, with another knot at 120 seconds. Two additional knots placed at -10 and 160 seconds were used to determine the derivatives of the spline function at the end points
    
* Other data saved:
  - Sp: [ord x 9] double, cardinal spline matrix
  - isis: [, x 1] double, inter-event-intervals in seconds

The function [build_design_mx](https://github.com/preraulab/Apnea_dynamics_toolbox/blob/master/Helper_functions/build_design_mx.m) is provided to reformat the saved data so they are be used to build design matrix and response for model fitting.

Usage:
```
[pos,sta,history,y,Sp,isis] = build_design_mx(bin,Fs_pos,ord,event_info,hypnogram,rawposition)

```


<br/>
<br/>



## Model Fitting
In Matlab, glmfit function is applied to fit the point process-GLM model.

* Input:
  - Design matrix: [pos sta history]
  - Response: y
  - Specify distribution: ‘poisson’
  - Include constant or not: ‘constant’, ‘off’ 

* Output:
  - b: fitted parameters
  - dev: deviance of the model
  - stats: a Matlab struct that contains all the information about the model fitting result, including coefficient estimates (b), covariance matrix for b, p-values for b, residuals, etc.


Usage:
```
[b, dev, stats] = glmfit([pos sta history],y,'poisson','constant','off');

```

<br/>
<br/>



## Model Visualization
To compute the predicted values for the GLM, glmval function is applied

* Input:
  - Fitted parameters: b 
  - Sp: the cardinal spline matrix
  - link function: ‘log’
  - stats: Matlab struct from the output of glmfit
  - Include constant or not: ‘constant’, ‘off’ 

* Output:
  - yhat: [150 x 1] vector, history dependence curve
  - ylo: yhat – ylo defines the 95% lower confidence bound of yhat
  - yhi: yhat + yhi defines the 95% upper confidence bound of yhat

Usage:
```
[yhat,ylo,yhi] = glmval(b,[zeros(150,6) Sp],'log',stats,'constant','off');

```

<br/>
<br/>





## Example Data
We apply the modeling approach to [four example subjects](https://github.com/preraulab/Apnea_dynamics_toolbox/tree/master/Example_data) from MESA dataset (the same 4 subjects as the Figure 1c in the paper), they have similar AHI (~ 15 events/hr) but very different history modulation structures. The [example script](https://github.com/preraulab/Apnea_dynamics_toolbox/blob/master/example_script.m) is provided in the repository to load the sample data, convert to the design matrix, run the model, output the results and generate history curves. (shown below)


<br/>
<p align="center">
<img src="https://github.com/preraulab/Apnea_dynamics_toolbox/blob/master/example_figure.jpg" width="1000" />
</p>


<br/>
<br/>



## Citations
The code contained in this repository is companion to the paper:  
> Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau*. Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing and a Statistical Framework for Phenotype Exploration, Sleep, 2022, zsac189, https://doi.org/10.1093/sleep/zsac189

which should be cited for academic use of this code.  

<br/>
<br/>

## Status

All implementations are functional, but are subject to refine. Last updated by SC, 08/08/2022













