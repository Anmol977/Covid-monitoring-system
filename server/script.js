const fs = require("fs");

class PatientData {
  constructor() {
    this.patientHeartData = {};
    this.patientSpo2Data = {};
    this.patientTempData = {};
    this.chiValue = 0;
  }
}

module.exports = PatientData;
