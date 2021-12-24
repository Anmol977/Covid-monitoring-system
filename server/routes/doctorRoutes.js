const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const logger = require('../logger');
const { doctorSignupValidation, doctorLogInValidation } = require('./doctorValidations');
const { doctorEmailExists, doctorPhoneExists, create, getDoctorDetails } = require('../stores/doctorStore');
const generateUserToken = require('../auth/jwt');

router.post('/doctor/signUp', async (req, res) => {
     const { error } = doctorSignupValidation(req.body)
     let user;
     if (error) {
          logger.error(error);
          return res.status(400).send(error.details[0].message);
     } else {
          try {
               const { email, phoneNumber, fullName, password } = req.body;
               let emailExists = await doctorEmailExists(email);
               if (emailExists) {
                    logger.info(`email ${email} already exists, unsuccessful signup attempt`);
                    return res
                         .status(400)
                         .send(
                              {
                                   error: `email ${email} already exists`,
                                   data: null
                              }
                         );
               }
               let phoneExists = await doctorPhoneExists(phoneNumber);
               if (phoneExists) {
                    logger.info(`number ${phoneNumber} already exists, unsuccessful signup attempt`);
                    return res
                         .status(400)
                         .send(
                              {
                                   error: `number ${phoneNumber} already exists`,
                                   data: null
                              }
                         );
               }
               let userId = await create({ email, phoneNumber, fullName, password });
               user = await getDoctorDetails(userId[0]);
               logger.info(`user created successfully, id : ${user.id}`);
               let token = generateUserToken({ id: userDetails.id, email: userDetails.email });
               res.cookie('authorization', token, { httpOnly: true });
               return res
                    .status(200)
                    .send(
                         {
                              message: 'user created successfully',
                              data: user
                         }
                    )
          } catch (e) {
               logger.error(e)
               return res.send({ message: e, data: null });
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
                              message: `email ${email} does not exist, failed to Log-In`,
                              data: null
                         })
               }
               else {
                    let userDetails = await getDoctorDetails(emailExists.id);
                    let passwordMatch = bcrypt.compareSync(password, emailExists.password);
                    if (passwordMatch) {
                         let token = generateUserToken({ id: userDetails.id, email: userDetails.email });
                         res.cookie('authorization', token, { httpOnly: true });
                         return res
                              .status(200)
                              .send({
                                   message: 'Logged In successfully',
                                   data: userDetails,
                              });
                    } else {
                         return res
                              .status(400)
                              .send({
                                   message: 'Incorrect Password, failed to Log-In',
                                   data: null
                              });
                    }
               }
          } catch (e) {
               logger.error(e);
               return res
                    .status(400)
                    .send({
                         message: e,
                         data: null
                    });
          }
     }
})


module.exports = router;
