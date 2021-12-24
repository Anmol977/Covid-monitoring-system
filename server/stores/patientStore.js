const db = require('../db');
const bcrypt = require('bcrypt');

module.exports = {
     create: async ({ email, fullName, password, dob, phoneNumber, roomNo }) => {
          email = email.toLowerCase();
          password = await bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
          return db('Patients').insert({ email, fullName, password, dob, phoneNumber, roomNo }).returning('id');
     },
     checkPatientExists: (id) => {
          return db('Patients').where({ id }).first();
     },
     patientEmailExists: (email) => {
          return db('Patients').where({ email }).first();
     },
     patientPhoneExists: (phoneNumber) => {
          return db('Patients').where({ phoneNumber }).first();
     },
     getPatientDetails: (id) => {
          return db('Patients').select('id', 'email', 'phoneNumber', 'roomNo', 'dob', 'fullName', 'SpO2', 'temperature', 'heartRate', 'status').where({ id }).first();
     }
}