Getting-and-Cleaning-Data-Course-Project
========================================


R script 'run_analysis.R' 
----
does the following:

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


'run_analysis.R' can be run as long as the [Samsung data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is in your working directory. The output is the tidy data set (file "tidy.txt").  

Run script from start to finish  


### Merge the training and the test sets to create one data set.
Combines data from different files to one data frame
Files: 
- "UCI HAR Dataset/train/y_train.txt"
- "UCI HAR Dataset/train/X_train.txt"
- "UCI HAR Dataset/train/subject_train.txt"
- "UCI HAR Dataset/test/y_test.txt"
- "UCI HAR Dataset/test/X_test.txt"
- "UCI HAR Dataset/test/subject_test.txt"

Data merge:  
`chunk1: 7352  observations       561 variables  + 2 variables(labels, subject)  `  
`chunk2: 2947  observations      561 variables  + 2 variables(labels, subject)  `  
`result: 10299 observations      563 variables  `  


Observations from X_test.txt and X_train.txt  
Variable "labels" form Test labels ("y_train.txt" and "y_test.txt")  
Variable "subject" form Subject identifiers (2 files named "subject_test.txt")  
You can view result in 'mergedData' table.  

### Extract only the measurements on the mean and standard deviation for each measurement. 

According to "features_info.txt" : "The set of variables that were estimated from these signals are: mean(): Mean value, std(): Standard deviation"  
Search for "std()" and "mean()" resuls in logical vector 'measurementsExtract', it defines which variable to extract from 'mergedData'  
Result of extraction saved in 'df' data frame  

### Use descriptive activity names to name the activities in the data set
Sequence of steps:
 1. get activty names from "UCI HAR Dataset/activity_labels.txt"  
 2. using numeric 'label' variable and corresponding activity names generate factor variable with levels: WALKING, WALKING_UPSTAIRS, + WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING  
 3. replace numeric 'label' variable with new factor   
now we have descriptive activity names


### Appropriately label the data set with descriptive variable names. 
Variable names (from UCI HAR Dataset/features.txt) already short and descriptive, but they contain symbols incompatible with syntactically valid variable name, and it would be hard to use this names in data manipulations.  The most straightforward way is to remove all invalid symbols.  
 1. get corresponding variable names from "UCI HAR Dataset/features.txt"  
 2. clean variables, creating syntactically valid names, removing symbols: __(__, __)__, __-__.  
 3. set column names (including renaming 'label' varible to 'activity', it is more descriptive)


### Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

The "melt" and "cast" functions are to be found in the "reshape" package  
If you do not have that package installed, then you will need to install it with install.packages("reshape") before you can use it  
Steps:  
 1. Melt data into a form suitable for casting, 'subject' and 'activity' variables are id variables, other variables are measured variables. This creates a new *tall* data set with  variables - subject, activity, variable, value  
 2. Cast a molten data frame into aggregated form (using mean as aggregate function)  
 3. Reorder created data frame by subject and activity to make it easier to scan the raw values  
 4. Write data frame to file "tidy.txt"  

This generates a tidy data text file that meets the principles of tidy data:  
 1. Each variable forms a column.                        
  + `one variable in each column, column headers are variable names`  
 2. Each observation forms a row.                        
  + `each row represents one observation`  
 3. Each type of observational unit forms a table.       
  + `data from multiple files combined into a single table`  
  
-------------------------------------------------------------------
 
tidy data can be read into R with read.table  

    df <- read.table("tidy.txt", sep=",", header=TRUE)  
    
For Specific description of the tidy data file contents (what variables used, names of columns, reference or link to original data info)
see CodeBook.md


