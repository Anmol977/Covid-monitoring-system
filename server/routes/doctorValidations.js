const joi = require('joi');

const doctorSignupValidation = data => {
     const schema = joi.object({
          fullName: joi.string().required(),
          email: joi.string().email().required(),
          phoneNumber: joi.string().required().max(10).min(10),
          password: joi.string().required(),
     })
     return schema.validate(data);
}

const doctorLogInValidation = data => {
     const schema = joi.object({
          fullName: joi.string(),
          email: joi.string().email().required(),
          phoneNumber: joi.string().max(10).min(10),
          password: joi.string().required(),
     })
     return schema.validate(data);
}

const doctorJwtValidation = data =>{
     const schema = joi.object({
          authorization : joi.required()
     }).unknown(true);
     return schema.validate(data);
}

const doctorPatientsListValidation = data =>{
     const schema = joi.object({
          patientsList : joi.string().required(),
          id : joi.string().required()
     })
     return schema.validate(data);
}

module.exports = { doctorSignupValidation, doctorLogInValidation, doctorJwtValidation, doctorPatientsListValidation };
