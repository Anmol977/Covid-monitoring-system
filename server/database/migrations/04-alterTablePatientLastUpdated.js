exports.up = function (knex) {
     return knex.schema.table('Patients', table => {
          table.date('lastUpdated');
     })
};

exports.down = function (knex) {
     return knex.schema.table('Patients', table => {
          table.dropColumn('lastUpdated');
     })
};