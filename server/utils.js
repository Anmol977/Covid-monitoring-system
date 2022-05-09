const logger = require("./logger");
const { patientEmailExists } = require("./stores/patientStore");
const patientStore = require('./stores/patientStore')

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
     classifyPatients : async (vitals, patientId) => {
          const {SpO2, temperature, heartRate} = vitals;
          const normalVals = {
               temperature : 37,
               heartRate : 72,
               oxygen : 95
          }
          let tempVariance = Math.pow(temperature - normalVals.temperature, 2)/normalVals.temperature;
          let heartRateVariance = Math.pow(heartRate - normalVals.heartRate, 2)/normalVals.heartRate;
          let oxygenVariance = Math.pow(SpO2 - normalVals.oxygen, 2)/normalVals.oxygen;
          let chiVal = Math.pow(tempVariance + heartRateVariance + oxygenVariance,0.5);
          logger.info(`calculated chi value is : ${chiVal}`);
          let oldChiVal = await patientStore.getPatientChi(patientId);
          let res = await patientStore.updatePatientChi(patientId);
          if(res){
               logger.info(`chi value of patient with id : ${patientId} was updated`)
          } else {
               logger.error('error updating patient chi value');
          }
          let diffChi = oldChiVal - chiVal;
          if(diffChi < 0 ){
               return 'serious';
          } else {
               return 'normal';
          }
     },
     sendPushNotif : () =>{

     }
}