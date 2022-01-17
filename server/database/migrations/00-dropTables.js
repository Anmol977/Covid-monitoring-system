exports.up = function (knex) {
    /**
     * For any new tables created after the last update of this file, they need to be added here.
     */
    return Promise.all([

         knex.raw('DROP TABLE IF EXISTS public."Patients" CASCADE'),
         knex.raw('DROP TABLE IF EXISTS public."Doctors" CASCADE'),
    ])
}

exports.down = function (knex) {
    return Promise.all([

    ])
}