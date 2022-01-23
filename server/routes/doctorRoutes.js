const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const logger = require('../logger');
const utils = require('../utils');
const doctorStore = require('../stores/doctorStore');
const patientStore = require('../stores/patientStore');
const { generateUserToken, validateJwtToken } = require('../auth/jwt');
const { checkDoctorExists, create, getDoctorDetails, doctorEmailExists, getDoctorAssignedPatients } = require('../stores/doctorStore');
const { doctorSignupValidation, doctorLogInValidation, doctorPatientsListValidation, doctorJwtValidation } = require('./doctorValidations');

router.post('/doctor/signUp', async (req, res, next) => {
     const { error } = doctorSignupValidation(req.body)
     let user;
     if (error) {
          logger.error(error);
          return res.status(400).send({
               error: error.details[0].message,
               message: utils.staticVars.GENERAL_ERROR
          });
     } else {
          try {
               const { email, phoneNumber, fullName, password } = req.body;
               let userExists = await checkDoctorExists(email, phoneNumber);
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
                    let token = generateUserToken({ id: user.id, email: user.email, scope: utils.staticVars.DOCTOR });
                    res.cookie('authorization', token, { httpOnly: true });
                    return res
                         .status(200)
                         .send(
                              {
                                   error: '',
                                   message: 'user created successfully',
                                   data: user,
                                   scope: utils.staticVars.DOCTOR
                              }
                         )
               }
          } catch (e) {
               logger.error(e)
               return res.status(500).send({ error: e, data: null });
          }
     }
})

router.post('/doctor/login/email', async (req, res, next) => {
     try {
          if (req.headers.authorization) {
               const { error } = doctorJwtValidation(req.headers);
               if (error) {
                    logger.error(error);
                    return res.status(400).send({ error: error.details[0].message });
               } else {
                    const token = req.headers.authorization;
                    const payload = validateJwtToken(token, res, next);
                    if (payload.scope === 'Doctor') {
                         let userDetails = await getDoctorDetails(payload.id);
                         if (userDetails) {
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
                                        error: utils.staticVars.GENERAL_ERROR,
                                        data: null
                                   });
                         }
                    }
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
                         let token = generateUserToken({ id: userDetails.id, email: userDetails.email, scope: utils.staticVars.DOCTOR });
                         res.cookie('authorization', token, { httpOnly: true });
                         return res
                              .status(200)
                              .send({
                                   error: '',
                                   message: 'Logged In successfully',
                                   data: userDetails,
                                   scope: utils.staticVars.DOCTOR
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
     const { error } = doctorJwtValidation(req.headers);
     if (error) {
          logger.error(error);
          res.status(401).send({
               error: error.details[0],
          })
     }
     else {
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
     }
})

router.post('/assignPatients', async (req, res, next) => {
     const { error } = doctorJwtValidation(req.headers);
     if (error) {
          logger.error(error);
          res.status(401).send({
               error: error.details[0],
          })
     } else {
          const { error } = doctorPatientsListValidation(req.body);
          if (error) {
               logger.error(error);
               res.status(400).send({
                    error: error.details[0]
               })
          } else {
               let token = req.headers.authorization;
               const payload = validateJwtToken(token, res, next);
               if (payload.scope === 'Doctor') {
                    const { patientsList, id } = req.body;
                    const response = await doctorStore.insertPatientsList(patientsList, id);
                    if (response) {
                         res.status(200).send({
                              error: '',
                              message: utils.staticVars.LIST_UPDATED,
                              data: null
                         })
                    }
                    else {
                         res.status(409).send({
                              error: utils.staticVars.GENERAL_ERROR,
                              message: utils.staticVars.LIST_ERROR,
                              data: null

                         })
                    }
               } else {
                    res
                         .status(401)
                         .send({
                              error: utils.staticVars.SCOPE_ERROR,
                              message: utils.staticVars.FETCH_ERROR,
                              data: null
                         })
               }
          }
     }

})

router.get('/doctor/getPatientVitals', async (req, res, next) => {
     const { error } = doctorJwtValidation(req.headers);
     if (error) {
          logger.error(error);
          res.status(401).send({
               error: error.details[0],
          })
     } else {
          try {
               let token = req.headers.authorization;
               const payload = validateJwtToken(token, res, next);
               if (payload.scope === 'Doctor') {
                    let patientsList = await getDoctorAssignedPatients(payload.id);
                    let patients = JSON.parse(patientsList.patientsAssigned);
                    let patientVitals;
                    let patientsVitalsList = [];
                    for await (let patient of patients) {
                         patientVitals = await patientStore.getPatientVitals(patient);
                         patientsVitalsList.push(patientVitals);
                    }
                    res.status(200).send({
                         error: '',
                         message: 'vitals fetched successfully',
                         data: patientsVitalsList
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
     }
})

module.exports = router;
