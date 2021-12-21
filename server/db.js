const {Pool,Client} = require('pg');
const cred = {
    user:"postgres",
    password:"shivam",
    host:"localhost",
    port:5432,
    database:"covmon"
}
const pool = new Pool(cred);




module.exports = pool;