const joi = require('Joi');

const signupValidation = data => {
     const schema = joi.object({
          fullName: joi.string().required(),
          email: joi.string().email().required(),
          phoneNumber: joi.string().required(),
          scope: joi.string().required(),
          password: joi.string().required(),
          dob: joi.date().required(),
          roomNo: joi.number().required()
     })
     return schema.validate(data);
}

const logInValidation = data => {
     const schema = joi.object({
          fullName: joi.string(),
          email: joi.string().email().required(),
          phoneNumber: joi.string(),
          password: joi.string().required(),
     })
     return schema.validate(data);
}

module.exports = { signupValidation, logInValidation };