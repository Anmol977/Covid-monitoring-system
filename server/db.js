<<<<<<< HEAD
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
=======
const { Pool } = require("pg");
const cred = {
  user: "postgres",
  password: "shivam",
  host: "localhost",
  port: 5432,
  database: "covmon",
};

const pool = new Pool(cred);

module.exports = pool;
>>>>>>> 6d5386b8096894303b56912a5b452e2bbae46b6f
