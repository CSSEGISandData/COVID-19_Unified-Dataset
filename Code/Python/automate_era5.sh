#!/bin/sh 
cd /mnt/sahara/data1/COVID/code/dataprocessing/

# Load necessary Python packages
source /mnt/sahara/data1/gaige/anaconda3/etc/profile.d/conda.sh
conda activate covid

# Redownload 2020 ERA5 data
echo "Downloading ERA5..."
python downloadERA5.py

# Move ERA5 files to proper directory
echo "Moving ERA5 files..."
rm /mnt/sahara/data1/COVID/ERA5/daily/era5-hourly-*-2020.nc 
mv era5-hourly-*-2020.nc /mnt/sahara/data1/COVID/ERA5/daily/

# Move old daily files to a separate directory
echo "Move old disaggregated files to continuity directory..." 
today=$(date '+%Y%m%d')  
mkdir /mnt/sahara/data1/COVID/ERA5/daily/2020/old_${today}
mv /mnt/sahara/data1/COVID/ERA5/daily/2020/ERA5_*.nc /mnt/sahara/data1/COVID/ERA5/daily/2020/old_${today}/

# Disaggregate yearly files into daily files by variable
echo "Disaggregating yearly files into daily files..."
python disaggregate_era5.py

# Move new daily files to 2020 directory
echo "Moving daily files to 2020 directory..."
mv /mnt/sahara/data1/COVID/ERA5/daily/ERA5_*.nc /mnt/sahara/data1/COVID/ERA5/daily/2020/

# Extract data at appropriate NUTS levels
echo "Extracting NUTS..." 
cd /mnt/sahara/data1/COVID/code/dataprocessing/ 
python extract_nuts_era5.py  
