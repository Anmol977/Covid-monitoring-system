exports.up = function (knex) {
    return knex.schema.alterTable('Patients', table => {
         table.decimal('chiValue');
    })
};

exports.down = function (knex) {
    return knex.schema.alterTable('Patients', table => {
         table.dropColumn('chiValue');
    })
};