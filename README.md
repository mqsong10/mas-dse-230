# DSE 230 Project - Predicting Arrests in Chicago

**Melody Song, Michael Sorenson, Tarik Basic**

This repo contains code to clean, extract, transform, and load data on crimes in Chicago from the city of Chicago(found [here](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present-Dashboard/5cd6-ry5g)) into a machine-learning-ready format for predicting whether or not a crime will lead to an arrest. It then tests three different machine learning models (logistic regression, decision trees, random forest) on the dataset to see how each model performs.

# Notebooks

1. EDA1: Startup & Data Cleaning
    * Locate and load dataset
    * Filter down dataset
    * Remove nulls
    * Perform categorical consolidation
    * Generate output csv for ingestion into other notebooks
2. EDA2: Visualization
    * Visualizing & describing dataset
    * Investigating feature relationships
3. Model Generation & Evaluation
    * Data preparation: one hot encoding, vectorization, etc.
    * Model training
    
## Notebook 1: Cleaning
This notebook is a short notebook that begins by starting a spark session (make sure to set local[2] to the number of threads on your computer) and importing the data. The notebook is expected to be run in a docker container that is started using the launch script *launch.sh* or *launch.ps1* (created by [Chaitanya Animesh](https://scholar.google.com/citations?user=xQOD9c8AAAAJ&hl=en)). The raw data file can be downloaded from the [city of Chicago](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present-Dashboard/5cd6-ry5g) at the export link. This CSV should be renamed to `crimes.csv`, and put in the `/home/work/Project/mas-dse-230/` directory. This notebook should then be run without error; it will count the nulls by year, remove 2001, drop null values, and consolidate the Primary Type and Description columns to get rid of redundancy. At the end of the notebook, the csv is saved to an output file `cleaned_crime.csv`, which will initially be a folder. The folder should contain `._SUCCESS.crc`, `.part-00000-...csv.crc`, `_SUCCESS` files, and a `part-00000-...csv` file. The .csv file should be renamed to cleaned_crime.csv and moved to `/home/work/Project/mas-dse-230/` (you will need to rename the folder before moving the file). Finally, you can delete the cleaned_crime.csv (or whatever you renamed it to) folder.

## Notebook 2: Visualization
This notebook is the main EDA notebook, and provides code to create many exploratory plots using the cleaned csv outputted from notebook 1. The notebook begins by examining ID and Case Number, then examines the Primary Type values and builds a pie plot for Primary Type counts. Next it examines the primary type frequencies by year in a stacked bar plot, then looks at the arrest rate of the top 20 primary types in a horizontal bar plot. Finally, we look at the number of crimes in each ward on a map, then look at the arrest rates of each ward on a map.

## Notebook 3: Modeling
This notebook is the main modeling notebook, and provides code to select features, transform them into a machine-learning-ready format, and train and test the models. Like notebook 2, this notebook reads the cleaned_crime.csv data that is outputted by notebook 1. The notebook begins by creating the Month and Hour features, and casting the target Arrest column to an int, to allow classifiers to fit to the data. We then split the data into a train and test subset, and then train and cross-validate a **logistic regression classifier** using the training data. The outputted model has a test accuracy of 79.9%, with the top coefficient being `Description = Aggression against a police officer with other dangerous weapon (i.e. not a knife or gun)`. After gathering some performance statistics about the logistic regression model, the notebook then moves on to train and cross-validate a **decision tree classifier**. The outputted model has a test accuracy of 88.6%, with a test ROC AUC of .637. Finally, we move on to the **random forest classifier**. This model has a test accuracy of 88.6% (same as decision tree), but has a much higher test ROC AUC of .894.
