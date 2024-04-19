# Age and Gender Dynamics in Traffic Accidents over Canada in 2019

## Paper Overview

This GitHub repo contains all files for paper *Age and Gender Dynamics in Traffic Accidents: A 2019 Canadian Case Study*. This study utilizes the 2019 National Collision Database and Driver’s License Statistics from Canada to explore the impact of age and gender on traffic collision rates through a Bayesian regression model.

The methodology and analytical strategies employed are learned from *Telling Stories with Data* by Rohan Alexander  (Alexander 2023).

## File Structure

The repo is structured as:

-   `data` contains the data used in this paper.
    - `data/Accident_rate_data` contains calculated collision rate for age and gender.
    - `data/Collision_data` contains raw, analysis, and simulaed data for collision data.
    - `data/Demographic_data` raw, analysis, and simulaed data for demographic data.
-   `models` ontains the statistical regression model that was constructed.
-   `other` contains sketches and llm
    - `other/sketches` contains sketches of dataset and graphs used in this paper.
    - `other/llm` contains the whole text of LLM usage.
-   `paper` contains the files used to generate the paper, including the datasheet, Quarto document and reference bibliography file, as well as the PDF of the datasheet and paper.
-   `scripts` contains the R scripts used to simulate, test, clean data and generate model for collision and demographic data. Also contains the scripts to calculate collision rate per 1000 drivers by age and gender. 

## Key Findings
Key insights from this research indicate that young drivers, particularly those aged 16-24, exhibit the highest rates of traffic accidents, while males are more frequently involved in collisions than females. These findings underline the importance of targeted educational programs and policy adjustments aimed at these demographic groups to enhance traffic safety.

## Usage
Instructions on how to replicate the analysis and utilize the scripts are provided, ensuring that researchers and policymakers can apply the findings of this study to similar datasets or further refine the analysis.

## License
This project is open-sourced under the MIT license.

## LLM Usage Statement
An LLM, in particular Chat-GPT3.5, was used to aid in the writing of this paper. In particular, it was primarily used to aid with the coding aspect of the paper as opposed to the actual writing. The entire chat history can be found in `other/llm/usage.txt`.
