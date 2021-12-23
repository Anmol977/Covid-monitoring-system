const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const logger = require('../logger');
const { signupValidation, logInValidation } = require('./validations');
const { userEmailExists, userPhoneExists, create, getUserDetails } = require('../stores/userStore');

router.post('/signUp', async (req, res, next) => {
     const { error } = signupValidation(req.body)
     let user;
     if (error) {
          return res.status(400).send(error.details[0].message);
     } else {
          try {
               const { email, phoneNumber, dob, fullName, scope, password, roomNo } = req.body;
               let emailExists = await userEmailExists(email);
               let phoneExists = await userPhoneExists(phoneNumber);
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
               user = await create({ email, phoneNumber, dob, fullName, scope, password, roomNo });
               logger.info(`user created successfully, id : ${user[0].id}`);
               return res
                    .status(200)
                    .send(
                         {
                              message: 'user created successfully',
                              data: user
                         }
                    )
          } catch (e) {
               return res.send({ message: e, data: null });
          }
     }
})

router.post('/login/email', async (req, res, next) => {
     const { error } = logInValidation(req.body);
     if (error) {
          return res.status(400).send(error.details[0].message);
     } else {
          try {
               const { email, phoneNumber, password } = req.body;
               let emailExists = await userEmailExists(email);
               if (!emailExists) {
                    return res
                         .status(400)
                         .send({
                              message: `email ${email} does not exist, failed to Log-In`,
                              data: null
                         })
               }
               else {
                    let userDetails = await getUserDetails(emailExists.id);
                    let passwordMatch = bcrypt.compareSync(password, emailExists.password);
                    if (passwordMatch) {
                         return res
                              .status(200)
                              .send({
                                   message: 'Logged In successfully',
                                   data: userDetails
                              })
                    } else {
                         return res
                              .status(400)
                              .send({
                                   message: 'Incorrect Password, failed to Log-In',
                                   data: null
                              })
                    }
               }
          } catch (e) {
               return res
                    .status(400)
                    .send({
                         message: e,
                         data: null
                    })
          }
     }
})

module.exports = router;
