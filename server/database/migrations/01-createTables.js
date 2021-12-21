exports.up = function (knex) {
     return Promise.all([

          knex.schema.raw('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'),

          knex.schema.createTable('Users', function (table) {
               table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'))
               table.string('email').unique()
               table.string('phoneNumber').unique()
               table.string('fullName').notNullable()
               table.string('password').notNullable()
               table.date('dob').notNullable()
               table.string('scope').notNullable()
               table.decimal('roomNo')
               table.decimal('temperature')
               table.decimal('SpO2')
               table.decimal('heartRate')
               table.string('doctorName')
               table.text('patientsAssigned')
          })
     ])
}

exports.down = function (knex) {
     return Promise.all([
          knex.raw('DROP TABLE IF EXISTS public."Users" CASCADE'),
     ])
}