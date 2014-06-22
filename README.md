The file run_ analysis.R contains the definition of the function run_analysis().

The function has been developed and tested under Linux (Ubuntu) but is prepared to run in other R-supported operating systems as Windows, etc.

The function performs the set of steps indicated for the assignment, and as a result writes a file TidyDataSet.txt containing the data set as specified in step 5 of the assigment, in the same folder where it is run.

The script informs with messages of the step is performin in every moment. This steps are:

- Read the column names from file 'features.txt', including 'subject' and 'activity'
- Builds the TEST data set,'cbinding' the files 'subject_ test.txt', 'y_ test.txt' and 'X_test.txt' in folder 'test'. This produces a data.frame

- Builds the TRAIN data set,'cbinding' the files 'subject_ train.txt', 'y_ train.txt' and 'X_train.txt' in folder 'train'. This produces a data.frame

- The TOTAL data.frame is built 'rbinding' both previously built data.frames (TEST and TRAIN)

- To the TOTAL data.frame is applied the column names previously read (first step in this description)

- To filter only those 'mean()' and 'std()' variables (as required by the assigment), a regular expresion ("[.]*mean\\ (\\)|std\\ (\\)[.] *") is used. Only variables which names comply with that expresion (plus subject and activity) are considered

- Then, the activity codes are changed to their descriptions (as in the provided file 'activity_labels.txt'), as required

- After that, the mean of every selected variable is calculated, per subject and activity combination. This produces a matrix that is converted to a data.frame and the column names are applied

- Finally, the column names for the variables are renamed as 'Mean(<originalName>)' to make explicit the kind of calculation performed on every variable

- The outcome is saved to a file 'TidyDataSet.txt' in the same folder where the processing has taken place

NOTE: The file run_analysis.R includes a function (checkfile()) useful to check the file generated with the function run _analysis(); it re-reads the file as a data.frame and displays some information on the object.



