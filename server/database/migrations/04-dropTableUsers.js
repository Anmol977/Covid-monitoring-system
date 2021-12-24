exports.up = function (knex) {
     return Promise.all([
          knex.raw('DROP TABLE IF EXISTS public."Users" CASCADE'),
     ])
}

exports.down = function (knex) {
     return Promise.all([

          knex.raw('DROP TABLE IF EXISTS public."Users" CASCADE'),

     ])
}