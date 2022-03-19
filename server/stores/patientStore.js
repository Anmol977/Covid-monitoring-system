const db = require('../db');
const bcrypt = require('bcrypt');

module.exports = {
     create: async ({ email, fullName, password, dob, phoneNumber, roomNo }) => {
          email = email.toLowerCase();
          password = await bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
          return db('Patients').insert({ email, fullName, password, dob, phoneNumber, roomNo }).returning('id');
     },
     checkPatientExists: (email, phoneNumber) => {
          let rawQuery = `SELECT (SELECT COUNT(patients."id") 
                         FROM public."Patients" as patients
                         WHERE  patients."email" = '${email}' OR patients."phoneNumber" = '${phoneNumber}')
                         +
                         (SELECT COUNT(doctors."id") 
                         FROM public."Doctors" as doctors
                         WHERE  doctors."email" = '${email}' OR doctors."phoneNumber" = '${phoneNumber}')
                         as sumCount`;
          return db.raw(rawQuery);
     },
     patientEmailExists: (email) => {
          return db('Patients').where({ email }).first();
     },
     patientPhoneExists: (phoneNumber) => {
          return db('Patients').where({ phoneNumber }).first();
     },
     getPatientDetails: (id) => {
          return db('Patients').select('id', 'email', 'phoneNumber', 'roomNo', 'dob', 'fullName', 'SpO2', 'temperature', 'heartRate', 'status', 'DoctorId').where({ id }).first();
     },
     getPatientsList: () => {
          return db('Patients').select('roomNo', 'fullName', 'id').where('DoctorId',null);
     },
     getPatientVitals: (id) => {
          return db('Patients').select('SpO2', 'fullName', 'roomNo', 'lastUpdated', 'SpO2', 'heartRate', 'temperature', 'status').where({ id }).first();
     },
     setPatientVitals : (id, data) =>{
          return db('Patients').where({id}).update({temperature:data.temperature, SpO2: data.SpO2, heartRate:data.heartRate});
     },
     updatePatientAssignedDoctor: (patientId, doctorId) => {
          return db('Patients').where({id:patientId}).update({DoctorId: doctorId});
     }
}
