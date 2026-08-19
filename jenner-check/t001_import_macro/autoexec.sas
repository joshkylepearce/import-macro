/* cap input rows for the captured run */
options obs=100;

/* Write a small sample CSV into the WORK library sandbox. This stands in
   for the file the author's %import macro would otherwise read from a
   real folder (their own example pointed at a UNC network share, which
   this bundle does not reuse). */
filename outcsv "%sysfunc(pathname(work))/tourism_sample.csv";
data _null_;
  file outcsv;
  put "region,visitors,year";
  put "North,1200,2023";
  put "South,980,2023";
  put "East,1450,2023";
  put "West,875,2023";
run;
