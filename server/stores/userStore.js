const db = require('../db');
const bcrypt = require('bcrypt');

module.exports = {
     create: async ({ email, fullName, password, dob, phoneNumber, roomNo, scope }) => {
          email = email.toLowerCase();
          password = await bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
          return db('Users').insert({ email, fullName, password, dob, phoneNumber, roomNo, scope }).returning('id');
     },
     checkUserExists: (id) => {
          return db('Users').where({ id }).first();
     },
     userEmailExists: (email) => {
          return db('Users').where({ email }).first();
     },
     userPhoneExists: (phoneNumber) => {
          return db('Users').where({ phoneNumber }).first();
     },
     getUserDetails: (id) => {
          return db('Users').select('id', 'email', 'phoneNumber', 'roomNo', 'scope', 'dob', 'fullName', 'SpO2', 'temperature', 'heartRate').where({ id }).first();
     }
}