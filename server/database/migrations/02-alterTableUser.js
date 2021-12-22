exports.up = function (knex) {
     return Promise.all([
          knex.schema.raw('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'),


          knex.schema.alterTable('Users', function (table) {
               table.text('roomNo').alter();
          })
     ])
}

exports.down = function (knex) {
     return Promise.all([

          knex.raw('DROP TABLE IF EXISTS public."Reviews" CASCADE'),

     ])
}