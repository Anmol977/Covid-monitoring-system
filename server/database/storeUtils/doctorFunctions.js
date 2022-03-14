const doctorStore = require('../../stores/doctorStore');
const patientStore = require('../../stores/patientStore');

async function getPatientsSortedList (id){
    let patientsList = await doctorStore.getDoctorAssignedPatients(id);
    if(patientsList.patientsAssigned == null)
        return [];
    let patients = JSON.parse(patientsList.patientsAssigned);
    let patientVitals;
    let patientsVitalsList = [];
    for await (let patient of patients) {
         patientVitals = await patientStore.getPatientVitals(patient);
         patientsVitalsList.push(patientVitals);
    }
    patientsVitalsList.sort((patient1,patient2)=>{
        if(patient1.status == 'normal' && patient2.status == 'normal')
            return 0;
        else if(patient1.status == 'normal' && patient2.status != 'normal')
            return 1;
        else 
            return -1;
    })
    return patientsVitalsList;
}

module.exports = getPatientsSortedList;