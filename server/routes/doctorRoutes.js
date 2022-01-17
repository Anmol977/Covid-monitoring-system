const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const logger = require('../logger');
const { doctorSignupValidation, doctorLogInValidation } = require('./doctorValidations');
const { checkDoctorExists, create, getDoctorDetails, doctorEmailExists } = require('../stores/doctorStore');
const { generateUserToken, validateJwtToken } = require('../auth/jwt');
const utils = require('../utils');
const patientStore = require('../stores/patientStore');
const { createGlobalSettings } = require('@angular/cli/utilities/config');

router.post('/doctor/signUp', async (req, res) => {
     const { error } = doctorSignupValidation(req.body)
     let user;
     if (error) {
          logger.error(error);
          return res.status(400).send(error.details[0].message);
     } else {
          try {
               const { email, phoneNumber, fullName, password } = req.body;
               let userExists = await checkDoctorExists(email, phoneNumber);
               console.log(userExists.rows[0].sumcount);
               if (userExists.rows[0].sumcount != 0) {
                    logger.info(`email ${email} or number ${phoneNumber} already exists, could not sign-up`);
                    return res
                         .status(400)
                         .send(
                              {
                                   error: utils.staticVars.SIGNUP_ERROR,
                                   message: utils.staticVars.ALREADY_EXISTS
                              }
                         );
               }
               else {
                    let userId = await create({ email, phoneNumber, fullName, password });
                    user = await getDoctorDetails(userId[0]);
                    logger.info(`user created successfully, id : ${user.id}`);
                    let token = generateUserToken({ id: user.id, email: user.email });
                    res.cookie('authorization', token, { httpOnly: true });
                    return res
                         .status(200)
                         .send(
                              {
                                   error: '',
                                   message: 'user created successfully',
                                   data: user
                              }
                         )
               }
          } catch (e) {
               logger.error(e)
               return res.status(500).send({ error: e, data: null });
          }
     }
})

router.post('/doctor/login/email', async (req, res) => {
     const { error } = doctorLogInValidation(req.body);
     if (error) {
          logger.error(error);
          return res.status(400).send(error.details[0].message);
     } else {
          try {
               const { email, password } = req.body;
               let emailExists = await doctorEmailExists(email);
               if (!emailExists) {
                    return res
                         .status(400)
                         .send({
                              error: `email ${email} does not exist, failed to Log-In`,
                              data: null
                         })
               }
               else {
                    let userDetails = await getDoctorDetails(emailExists.id);
                    let passwordMatch = bcrypt.compareSync(password, emailExists.password);
                    if (passwordMatch) {
                         let token = generateUserToken({ id: userDetails.id, email: userDetails.email, scope: 'Doctor' });
                         res.cookie('authorization', token, { httpOnly: true });
                         return res
                              .status(200)
                              .send({
                                   error: '',
                                   message: 'Logged In successfully',
                                   data: userDetails,
                              });
                    } else {
                         return res
                              .status(400)
                              .send({
                                   error: 'Incorrect Password, failed to Log-In',
                                   data: null
                              });
                    }
               }
          } catch (e) {
               logger.error(e);
               return res
                    .status(500)
                    .send({
                         error: e,
                         data: null
                    });
          }
     }
})

router.get('/doctor/details', async (req, res, next) => {
     try {
          const token = req.headers.authorization;
          const payload = validateJwtToken(token, res, next);
          if (typeof payload !== 'undefined') {
               let doctorDetails = await getDoctorDetails(payload.id);
               if (doctorDetails) {
                    res.status(200).send({ error: '', message: utils.staticVars.SUCCESS_FETCH, doctorDetails });
               } else {
                    res.status(404).send({ error: utils.staticVars.GENERAL_ERROR });
               }
          }
     } catch (e) {
          logger.error(e);
          res.status(500).send({ error: e });
     }
})

router.get('/patients/list', async (req, res, next) => {
     try {
          const token = req.headers.authorization;
          const payload = validateJwtToken(token, res, next);
          if (payload.scope === 'Doctor') {
               let patientsList = await patientStore.getPatientsList();
               res
                    .status(200)
                    .send({
                         error: '',
                         message: 'fetched patients list successfully',
                         data: patientsList
                    })
          } else {
               res
                    .status(401)
                    .send({
                         error: utils.staticVars.SCOPE_ERROR,
                         message: utils.staticVars.FETCH_ERROR,
                         data: null
                    })
          }
     } catch (e) {
          logger.error(e);
          res.status(500).send({ error: e });
     }
})

module.exports = router;
