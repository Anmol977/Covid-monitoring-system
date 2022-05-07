
module.exports = {
     staticVars: {
          SUCCESS_FETCH: 'Details fetched successfully',
          GENERAL_ERROR: 'Something went wrong',
          SIGNUP_ERROR: 'unable to sign-up',
          ALREADY_EXISTS: 'email or phone number already exists',
          SCOPE_ERROR: 'incorrect customer scope',
          FETCH_ERROR: 'error fetching details',
          LIST_UPDATED: 'patients list updated successfully',
          LIST_ERROR: 'error updating patients list',
          PATIENT: 'Patient',
          DOCTOR: 'Doctor',
          AUTH_ERROR : 'user not authorized to do this action',
          VITALS_SUCCESS : 'user vitals updated successfully',
     },
     classifyPatients : (vitals) => {
          const {SpO2, temperature, heartRate} = vitals;
          if(SpO2 > 95 || heartRate <= 100 || temperature <=37.2)
               return 'non-symptomatic';
          if( SpO2 > 95 || heartRate <= 100 || 37 < temperature <=38)
               return 'mild';
          if( 93 < SpO2 < 95 || heartRate > 120 || temperature >=38)
               return 'serious';
          if( SpO2 < 92 || heartRate > 120 || temperature >=38)
               return 'occurance of comorbidities';
     },
     sendPushNotif : () =>{

     }
}