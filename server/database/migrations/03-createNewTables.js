exports.up = function (knex) {
     return Promise.all([

          knex.schema.raw('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'),

          knex.schema.createTable('Patients', function (table) {
               table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'))
               table.string('email').unique()
               table.string('phoneNumber').unique()
               table.string('fullName').notNullable()
               table.string('password').notNullable()
               table.date('dob').notNullable()
               table.decimal('roomNo')
               table.decimal('temperature')
               table.decimal('SpO2')
               table.decimal('heartRate')
               table.string('status')
          }),

          knex.schema.createTable('Doctors', function (table) {
               table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'))
               table.string('email').unique()
               table.string('phoneNumber').unique()
               table.string('fullName').notNullable()
               table.string('password').notNullable()
               table.text('patientsAssigned')
          })
     ])
}

exports.down = function (knex) {
     return Promise.all([
          knex.raw('DROP TABLE IF EXISTS public."Patients" CASCADE'),
          knex.raw('DROP TABLE IF EXISTS public."Doctors" CASCADE')
     ])
}