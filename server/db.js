const knex = require('knex')({
    client: 'pg',
    connection: {
        host: 'localhost',
        port: 5432,
        user: process.env.POSTGRES_USER,
        password: process.env.POSTGRES_PASS,
        database: 'covmon'
    },
    migrations: {
        tableName: "knex_migrations",
        directory: __dirname + "/database/migrations",
    },
});

module.exports = knex;
