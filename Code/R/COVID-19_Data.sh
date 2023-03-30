# .bashrc                                                               #

if [[ ! -f "COVID-19.rds" ]]; then
    time $runDir/COVID-19/Modeling/COVID-19_Data.R
fi

if [[ ! -f "Policy.rds" ]]; then
    wget http://oxcgrtportal.azurewebsites.net/api/csvdownload?type=subnational_brazil_imputed || :
    if [[ -f csvdownload?type=subnational_brazil_imputed ]]; then
      mv csvdownload?type=subnational_brazil_imputed OxCGRT_Brazil_latest.csv || :
    fi

    time $runDir/COVID-19/Modeling/COVID-19_Policy.R
fi

if [[ ! -f "Vaccine.rds" ]]; then
    time $runDir/COVID-19/Modeling/COVID-19_Vaccine.R
fi

if [[ ! -f "COVID-19_Static.rds" ]]; then
    time $runDir/COVID-19/Modeling/COVID-19_Static.R
fi

if [[ ! -f "Hydromet.rds" ]]; then
    time $runDir/COVID-19/Modeling/Hydromet.R
fi

cd $runDir/COVID-19/COVID-19_Unified-Dataset
git reset --hard
git clean -fdx
git pull
cp -pv ../Outputs/COVID-19*.csv* ../Outputs/COVID-19.* .
cp -pv ../Outputs/COVID-19_Static.* . 2>/dev/null || :
cp -pv ../Outputs/Policy.* . 2>/dev/null || :
cp -pv ../Outputs/Vaccine.* . 2>/dev/null || :
cp -pv ../Outputs/Hydromet_*.* Hydromet/ 2>/dev/null || :
#rm -f Hydromet/Hydromet_missing.csv COVID-19_LUT_Full.csv || :
git status
git diff
echo 'git add -A && git commit -am "Updated dataset ($(date))"'
