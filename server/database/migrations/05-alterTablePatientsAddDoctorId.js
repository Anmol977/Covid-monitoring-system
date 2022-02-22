exports.up = function (knex) {
    return knex.schema.table('Patients', table => {
         table.uuid('DoctorId');
    })
};

exports.down = function (knex) {
    return knex.schema.table('Patients', table => {
         table.dropColumn('DoctorId');
    })
};