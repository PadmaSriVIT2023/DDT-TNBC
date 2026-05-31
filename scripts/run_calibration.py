import sys
sys.path.append('.')
from ddt import calibrate_dram, load_patient_data
import pandas as pd

def main():
    # Load all 85 patients
    patients = pd.read_csv('data/patient_list.csv')
    results = []
    for pid in patients['patient_id']:
        data = load_patient_data(f'data/{pid}/clinical.csv')
        trace = calibrate_dram(data, prior_means, prior_sds)
        # Save posterior
        trace.to_netcdf(f'output/{pid}_posterior.nc')
        results.append({'pid': pid, 'success': True})
    pd.DataFrame(results).to_csv('output/calibration_summary.csv', index=False)

if __name__ == '__main__':
    main()
