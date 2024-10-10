# Clustering Outlier Detection Method in Big Data

## Overview

This repository presents a new ensemble method for detecting outliers in big data using a clustering-based approach. The method is capable of identifying both local and global outliers and employs Locality Sensitive Hashing (LSH) for dimensionality reduction, followed by various clustering algorithms to calculate outlier scores.

## Methodology

The proposed method consists of six main stages:

1. **Bagging**: The dataset is divided into 10 bags, each containing 20% of the original data, drawn with replacement.
2. **Locality Sensitive Hashing (LSH)**: Reduces the dimensionality of the dataset to 20 dimensions.
3. **K-means Clustering**: The K-means algorithm is applied on each subsample using different values for \( k \) (3, 5, 7, 9, 13, 17, 20).
4. **Entropy Difference**: Calculate the entropy difference to assess the variability of data points within clusters.
5. **Assigning Outlier Scores**: Outlier scores are computed based on the entropy differences obtained in the previous step.
6. **Support Vector Machine (SVM) with Voting**: A small labeled dataset is used to train the SVM, which predicts outliers and calculates the Area Under the Curve (AUC).

## Datasets

The experiments were conducted on both real and synthetic datasets. The NSL-KDD dataset was used to address the shortcomings of the original KDD dataset, ensuring a rational distribution of records across various difficulty levels. 

### Summary of Datasets

#### Real Datasets
| Dataset            | #Data | #Dimension | #Outliers | Clustering AUC | iforest AUC | LOF AUC | LoOP AUC | OCSVM AUC |
|--------------------|-------|------------|-----------|----------------|-------------|---------|----------|------------|
| Wbc                | 278   | 30         | 21        | 0.634          | 0.9354      | 0.9937  | 0.9692   | 0.8214     |
| Speech             | 3686  | 400        | 61        | 0.7557         | 0.4849      | 0.5320  | 0.5025   | 0.6198     |
| Satimage-2        | 5803  | 36         | 71        | 0.8612         | 0.9935      | 0.6083  | 0.4964   | 0.9335     |
| ...                | ...   | ...        | ...       | ...            | ...         | ...     | ...      | ...        |

#### Synthetic Datasets
| Dataset            | #Data | #Dimension | #Outliers | Clustering AUC | iforest AUC | LOF AUC | LoOP AUC | OCSVM AUC |
|--------------------|-------|------------|-----------|----------------|-------------|---------|----------|------------|
| Out-35            | 35600 | 102        | 600       | 0.9932         | 1           | -       | -        | 0.589      |
| Out-100           | 100200| 102        | 200       | 0.9910         | 0.9943      | -       | -        | 0.603      |

## Results

The results demonstrate that the proposed method outperforms existing techniques like Isolation Forest (iforest), Local Outlier Factor (LOF), Local Outlier Probability (LoOP), and One-Class SVM (OCSVM) in most scenarios, particularly in detecting collective outliers.

## How to Use the Code

To run the code, follow these steps:

1. **Setup**: Ensure you have MATLAB installed on your system.

2. **File Structure**: The repository contains six main files, each corresponding to a stage in the outlier detection process:
   - `1_bagging.m`: Handles the bagging process to create subsamples of the dataset.
   - `2_lsh.m`: Implements Locality Sensitive Hashing for dimensionality reduction.
   - `3_kmeans.m`: Applies K-means clustering with varying \( k \) values to the subsamples.
   - `4_entropy_difference.m`: Calculates the entropy differences for the clusters formed.
   - `5_outlier_scores.m`: Assigns outlier scores based on the entropy differences.
   - `6_svm_voting.m`: Trains the SVM and predicts outliers using the assigned scores .

3. **Execution**:
   - Open each of the main files in MATLAB.
   - Run the files in the order listed above (from `1_bagging.m` to `6_svm_voting.m`).
   - Ensure to modify any dataset paths within the scripts if necessary.

4. **Results**: The output will provide the AUC results for the various methods compared, allowing you to evaluate the effectiveness of the proposed ensemble method.

## Conclusion

This repository provides a robust framework for outlier detection in big data using an ensemble approach. The methodology demonstrates effectiveness across different datasets and offers insights into the performance of various outlier detection techniques.
