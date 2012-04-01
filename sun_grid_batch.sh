#!/bin/sh

DATASET="${SGE_TASK}"
LFP_OR_NEUR="LFP"
FUNC="save_LFP_regression_results"

# Analyze data set.
matlab_exec=matlab
func_call="batch_master('${LFP_OR_NEUR}', '${DATASET}', '${FUNC}')"
echo ${func_call} > temp_${DATASET}.m
${matlab_exec} -nojvm -nodisplay -nosplash < temp_${DATASET}.m
rm temp_${DATASET}.m