exports.up = function (knex) {
    return knex.schema.alterTable('Patients', table => {
         table.timestamp('lastUpdated').alter();
    })
};

exports.down = function (knex) {
    return knex.schema.alterTable('Patients', table => {
         table.dropColumn('lastUpdated');
    })
};