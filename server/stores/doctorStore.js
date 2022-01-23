const db = require('../db');
const bcrypt = require('bcrypt');
const { query } = require('express');

module.exports = {
     create: async ({ email, fullName, password, phoneNumber }) => {
          email = email.toLowerCase();
          password = await bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
          return db('Doctors').insert({ email, fullName, password, phoneNumber }).returning('id');
     },
     checkDoctorExists: (email, phoneNumber) => {
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
     doctorEmailExists: (email) => {
          return db('Doctors').where({ email }).first();
     },
     doctorPhoneExists: (phoneNumber) => {
          return db('Doctors').where({ phoneNumber }).first();
     },
     getDoctorDetails: (id) => {
          return db('Doctors').select('id', 'email', 'phoneNumber', 'fullName', 'patientsAssigned').where({ id }).first();
     },
     insertPatientsList: (patientsList, id) => {
          return db('Doctors').where({ id }).update({ patientsAssigned: patientsList });
     },
     getDoctorAssignedPatients: (id) => {
          return db('Doctors').select('patientsAssigned').where({ id }).first();
     }
}