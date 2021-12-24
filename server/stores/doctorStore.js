const db = require('../db');
const bcrypt = require('bcrypt');

module.exports = {
     create: async ({ email, fullName, password, phoneNumber }) => {
          email = email.toLowerCase();
          password = await bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
          return db('Doctors').insert({ email, fullName, password, phoneNumber }).returning('id');
     },
     checkDoctorExists: (id) => {
          return db('Doctors').where({ id }).first();
     },
     doctorEmailExists: (email) => {
          return db('Doctors').where({ email }).first();
     },
     doctorPhoneExists: (phoneNumber) => {
          return db('Doctors').where({ phoneNumber }).first();
     },
     getDoctorDetails: (id) => {
          return db('Doctors').select('id', 'email', 'phoneNumber', 'fullName', 'patientsAssigned').where({ id }).first();
     }
}