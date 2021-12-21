const knex = require('knex')({
    client: 'pg',
    connection: {
        host: 'localhost',
        port: 5432,
        user: 'postgres',
        password: 'shivam',
        database: 'covmon'
    },
    migrations: {
        tableName: "knex_migrations",
        directory: __dirname + "/database/migrations",
    },
});

module.exports = knex;
