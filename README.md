# Ensemble Learner for Fault Diagnosis using Visual Dot Patterns
The repository presents an engine-fault detection method based on symmetrized dot pattern (SDP) analysis of acoustic and vibration signals and image matching, which can timely and accurately monitor the engine conditions at various rotation speeds in real-time.

## Data
Dataset includes acoustic signals, acquired at the rotational speeds of 1500, 2000, 2500 and 3000, with five categories of engines conditions:
- Normal (0)
- Lean (1)
- Rich (2)
- Spark Advance (3)
- Spark Retard (4)

Note: The signals are in Technical Data Management Streaming (TDMS) format, and therefore require <a href="https://www.mathworks.com/matlabcentral/fileexchange/30023-tdms-reader">TDMS Reader</a> for reading the data into MATLAB's workspace.

## Ensemble Classifier
The classifer runs on 100 iterations and uses Bagging method and a Decision-Trees template to learn the signal features. The model performance and final classification results are represented in the figures below.
<p align="center">
  <img src="https://github.com/rimshasaeed/Fault-Diagnosis-using-Visual-Dot-Patterns-of-Acoustic-and-Vibration-Signals/blob/main/result/figure1.jpg", alt="pre-processing" width="50%">
  <br>
  <i>Model Performance during Training</i>
</p>
<p align="center">
  <img src="https://github.com/rimshasaeed/Fault-Diagnosis-using-Visual-Dot-Patterns-of-Acoustic-and-Vibration-Signals/blob/main/result/figure2.jpg", alt="pre-processing" width="50%">
  <br>
  <i>Test-set Predictions</i>
</p>
